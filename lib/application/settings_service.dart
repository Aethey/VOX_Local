import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../domain/models.dart';
import '../domain/ports.dart';
import 'observable.dart';

part 'settings_service.freezed.dart';
part 'settings_service.g.dart';

@freezed
abstract class SettingsState with _$SettingsState {
  const SettingsState._();
  const factory SettingsState({
    ProviderProfile? profile,
    @Default(AnalysisTemplate.actions) AnalysisTemplate template,
    @Default([]) List<AnalysisTemplate> customTemplates,
    @Default(30) int interval,
    @Default(false) bool analysisEnabled,
    @Default('turbo') String model,
    @Default('zh') String language,

    /// Language the provider writes analysis findings in.
    @Default('zh') String analysisLanguage,
    @Default('system') String uiLocale,
  }) = _SettingsState;
  factory SettingsState.fromJson(Map<String, dynamic> json) =>
      _$SettingsStateFromJson(json);
  static const analysisLanguages = ['zh', 'ja', 'en'];
  SettingsState copy({
    ProviderProfile? profile,
    AnalysisTemplate? template,
    List<AnalysisTemplate>? customTemplates,
    int? interval,
    bool? analysisEnabled,
    String? model,
    String? language,
    String? analysisLanguage,
    String? uiLocale,
  }) => copyWith(
    profile: profile ?? this.profile,
    template: template ?? this.template,
    customTemplates: customTemplates ?? this.customTemplates,
    interval: interval ?? this.interval,
    analysisEnabled: analysisEnabled ?? this.analysisEnabled,
    model: model ?? this.model,
    language: language ?? this.language,
    analysisLanguage: analysisLanguage ?? this.analysisLanguage,
    uiLocale: uiLocale ?? this.uiLocale,
  );
}

class SettingsService extends ObservableState<SettingsState> {
  SettingsService(this.store, this.credentials) : super(const SettingsState());
  final LocalStore store;
  final CredentialStore credentials;
  Future<void> restore() async {
    final saved = await store.setting('settings');
    if (saved != null) emit(SettingsState.fromJson(jsonDecode(saved)));
  }

  Future<void> update(SettingsState next) async {
    if (!['system', 'zh', 'ja', 'en'].contains(next.uiLocale)) {
      throw const FormatException('unsupportedLocale');
    }
    if (![10, 30, 60, 120, 300].contains(next.interval)) {
      throw const FormatException('unsupportedInterval');
    }
    if (!SettingsState.analysisLanguages.contains(next.analysisLanguage)) {
      throw const FormatException('unsupportedAnalysisLanguage');
    }
    await store.saveSetting('settings', jsonEncode(next.toJson()));
    emit(next);
  }

  /// Removes the provider profile and its credential from secure storage.
  /// Recordings that still reference the profile block until it is saved again.
  Future<void> clearProfile() async {
    final current = value.profile;
    if (current == null) return;
    await credentials.delete(current.credentialRef);
    await update(value.copyWith(profile: null, analysisEnabled: false));
  }

  static ProviderProfile profileFor(
    String provider,
    String endpoint,
    String model,
  ) {
    final normalized = endpoint.trim().replaceFirst(RegExp(r'/+$'), '');
    final id = sha256
        .convert(utf8.encode('$provider|$normalized|${model.trim()}'))
        .toString()
        .substring(0, 24);
    return ProviderProfile(
      id: id,
      provider: provider,
      endpoint: normalized,
      model: model.trim(),
      credentialRef: 'vox.provider.$id',
    );
  }

  Future<void> saveProfile(
    ProviderProfile profile,
    String? newCredential,
  ) async {
    profile.validate();
    if (newCredential != null && newCredential.trim().isNotEmpty) {
      await credentials.write(profile.credentialRef, newCredential.trim());
    }
    final key = await credentials.read(profile.credentialRef);
    if (key == null || key.isEmpty) {
      throw const FormatException('enterApiKey');
    }
    await update(value.copy(profile: profile));
  }

  Future<void> saveTemplate(AnalysisTemplate template) async {
    if (template.name.trim().isEmpty ||
        template.instruction.trim().isEmpty ||
        template.instruction.length > 4000) {
      throw const FormatException('invalidTemplate');
    }
    final templates =
        value.customTemplates.where((t) => t.id != template.id).toList()
          ..add(template);
    await update(
      value.copy(
        template: template,
        customTemplates: List.unmodifiable(templates),
      ),
    );
  }
}

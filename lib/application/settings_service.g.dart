// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_service.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettingsState _$SettingsStateFromJson(Map<String, dynamic> json) =>
    _SettingsState(
      profile: json['profile'] == null
          ? null
          : ProviderProfile.fromJson(json['profile'] as Map<String, dynamic>),
      template: json['template'] == null
          ? AnalysisTemplate.actions
          : AnalysisTemplate.fromJson(json['template'] as Map<String, dynamic>),
      customTemplates:
          (json['customTemplates'] as List<dynamic>?)
              ?.map((e) => AnalysisTemplate.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      interval: (json['interval'] as num?)?.toInt() ?? 30,
      analysisEnabled: json['analysisEnabled'] as bool? ?? false,
      model: json['model'] as String? ?? 'turbo',
      language: json['language'] as String? ?? 'zh',
      analysisLanguage: json['analysisLanguage'] as String? ?? 'zh',
      uiLocale: json['uiLocale'] as String? ?? 'system',
    );

Map<String, dynamic> _$SettingsStateToJson(
  _SettingsState instance,
) => <String, dynamic>{
  'profile': instance.profile?.toJson(),
  'template': instance.template.toJson(),
  'customTemplates': instance.customTemplates.map((e) => e.toJson()).toList(),
  'interval': instance.interval,
  'analysisEnabled': instance.analysisEnabled,
  'model': instance.model,
  'language': instance.language,
  'analysisLanguage': instance.analysisLanguage,
  'uiLocale': instance.uiLocale,
};

// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$SettingsState {

 ProviderProfile? get profile; AnalysisTemplate get template; List<AnalysisTemplate> get customTemplates; int get interval; bool get analysisEnabled; String get model; String get language;/// Language the provider writes analysis findings in.
 String get analysisLanguage; String get uiLocale;
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStateCopyWith<SettingsState> get copyWith => _$SettingsStateCopyWithImpl<SettingsState>(this as SettingsState, _$identity);

  /// Serializes this SettingsState to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as SettingsState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState&&(identical(other.profile, _this.profile) || other.profile == _this.profile)&&(identical(other.template, _this.template) || other.template == _this.template)&&const DeepCollectionEquality().equals(other.customTemplates, _this.customTemplates)&&(identical(other.interval, _this.interval) || other.interval == _this.interval)&&(identical(other.analysisEnabled, _this.analysisEnabled) || other.analysisEnabled == _this.analysisEnabled)&&(identical(other.model, _this.model) || other.model == _this.model)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.analysisLanguage, _this.analysisLanguage) || other.analysisLanguage == _this.analysisLanguage)&&(identical(other.uiLocale, _this.uiLocale) || other.uiLocale == _this.uiLocale));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as SettingsState;
  return Object.hash(runtimeType,_this.profile,_this.template,const DeepCollectionEquality().hash(_this.customTemplates),_this.interval,_this.analysisEnabled,_this.model,_this.language,_this.analysisLanguage,_this.uiLocale);
}

@override
String toString() {
  final _this = this as SettingsState;
  return 'SettingsState(profile: ${_this.profile}, template: ${_this.template}, customTemplates: ${_this.customTemplates}, interval: ${_this.interval}, analysisEnabled: ${_this.analysisEnabled}, model: ${_this.model}, language: ${_this.language}, analysisLanguage: ${_this.analysisLanguage}, uiLocale: ${_this.uiLocale})';
}


}

/// @nodoc
abstract mixin class $SettingsStateCopyWith<$Res>  {
  factory $SettingsStateCopyWith(SettingsState value, $Res Function(SettingsState) _then) = _$SettingsStateCopyWithImpl;
@useResult
$Res call({
 ProviderProfile? profile, AnalysisTemplate template, List<AnalysisTemplate> customTemplates, int interval, bool analysisEnabled, String model, String language, String analysisLanguage, String uiLocale
});


$ProviderProfileCopyWith<$Res>? get profile;$AnalysisTemplateCopyWith<$Res> get template;

}
/// @nodoc
class _$SettingsStateCopyWithImpl<$Res>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._self, this._then);

  final SettingsState _self;
  final $Res Function(SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profile = freezed,Object? template = null,Object? customTemplates = null,Object? interval = null,Object? analysisEnabled = null,Object? model = null,Object? language = null,Object? analysisLanguage = null,Object? uiLocale = null,}) {
  return _then(SettingsState(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as ProviderProfile?,template: null == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as AnalysisTemplate,customTemplates: null == customTemplates ? _self.customTemplates : customTemplates // ignore: cast_nullable_to_non_nullable
as List<AnalysisTemplate>,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,analysisEnabled: null == analysisEnabled ? _self.analysisEnabled : analysisEnabled // ignore: cast_nullable_to_non_nullable
as bool,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,analysisLanguage: null == analysisLanguage ? _self.analysisLanguage : analysisLanguage // ignore: cast_nullable_to_non_nullable
as String,uiLocale: null == uiLocale ? _self.uiLocale : uiLocale // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProviderProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $ProviderProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalysisTemplateCopyWith<$Res> get template {
  
  return $AnalysisTemplateCopyWith<$Res>(_self.template, (value) {
    return _then(_self.copyWith(template: value));
  });
}
}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns on SettingsState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsState value)  $default,){
final _that = this;
switch (_that) {
case _SettingsState():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ProviderProfile? profile,  AnalysisTemplate template,  List<AnalysisTemplate> customTemplates,  int interval,  bool analysisEnabled,  String model,  String language,  String analysisLanguage,  String uiLocale)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.profile,_that.template,_that.customTemplates,_that.interval,_that.analysisEnabled,_that.model,_that.language,_that.analysisLanguage,_that.uiLocale);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ProviderProfile? profile,  AnalysisTemplate template,  List<AnalysisTemplate> customTemplates,  int interval,  bool analysisEnabled,  String model,  String language,  String analysisLanguage,  String uiLocale)  $default,) {final _that = this;
switch (_that) {
case _SettingsState():
return $default(_that.profile,_that.template,_that.customTemplates,_that.interval,_that.analysisEnabled,_that.model,_that.language,_that.analysisLanguage,_that.uiLocale);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ProviderProfile? profile,  AnalysisTemplate template,  List<AnalysisTemplate> customTemplates,  int interval,  bool analysisEnabled,  String model,  String language,  String analysisLanguage,  String uiLocale)?  $default,) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.profile,_that.template,_that.customTemplates,_that.interval,_that.analysisEnabled,_that.model,_that.language,_that.analysisLanguage,_that.uiLocale);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _SettingsState extends SettingsState {
  const _SettingsState({this.profile, this.template = AnalysisTemplate.actions,  List<AnalysisTemplate> customTemplates = const [], this.interval = 30, this.analysisEnabled = false, this.model = 'turbo', this.language = 'zh', this.analysisLanguage = 'zh', this.uiLocale = 'system'}): _customTemplates = customTemplates,super._();
  factory _SettingsState.fromJson(Map<String, dynamic> json) => _$SettingsStateFromJson(json);

@override final  ProviderProfile? profile;
@override@JsonKey() final  AnalysisTemplate template;
 final  List<AnalysisTemplate> _customTemplates;
@override@JsonKey() List<AnalysisTemplate> get customTemplates {
  if (_customTemplates is EqualUnmodifiableListView) return _customTemplates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_customTemplates);
}

@override@JsonKey() final  int interval;
@override@JsonKey() final  bool analysisEnabled;
@override@JsonKey() final  String model;
@override@JsonKey() final  String language;
/// Language the provider writes analysis findings in.
@override@JsonKey() final  String analysisLanguage;
@override@JsonKey() final  String uiLocale;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsStateCopyWith<_SettingsState> get copyWith => __$SettingsStateCopyWithImpl<_SettingsState>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SettingsStateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsState&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.template, template) || other.template == template)&&const DeepCollectionEquality().equals(other.customTemplates, _customTemplates)&&(identical(other.interval, interval) || other.interval == interval)&&(identical(other.analysisEnabled, analysisEnabled) || other.analysisEnabled == analysisEnabled)&&(identical(other.model, model) || other.model == model)&&(identical(other.language, language) || other.language == language)&&(identical(other.analysisLanguage, analysisLanguage) || other.analysisLanguage == analysisLanguage)&&(identical(other.uiLocale, uiLocale) || other.uiLocale == uiLocale));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,profile,template,const DeepCollectionEquality().hash(_customTemplates),interval,analysisEnabled,model,language,analysisLanguage,uiLocale);
}

@override
String toString() {
    return 'SettingsState(profile: $profile, template: $template, customTemplates: $customTemplates, interval: $interval, analysisEnabled: $analysisEnabled, model: $model, language: $language, analysisLanguage: $analysisLanguage, uiLocale: $uiLocale)';
}


}

/// @nodoc
abstract mixin class _$SettingsStateCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory _$SettingsStateCopyWith(_SettingsState value, $Res Function(_SettingsState) _then) = __$SettingsStateCopyWithImpl;
@override @useResult
$Res call({
 ProviderProfile? profile, AnalysisTemplate template, List<AnalysisTemplate> customTemplates, int interval, bool analysisEnabled, String model, String language, String analysisLanguage, String uiLocale
});


@override $ProviderProfileCopyWith<$Res>? get profile;@override $AnalysisTemplateCopyWith<$Res> get template;

}
/// @nodoc
class __$SettingsStateCopyWithImpl<$Res>
    implements _$SettingsStateCopyWith<$Res> {
  __$SettingsStateCopyWithImpl(this._self, this._then);

  final _SettingsState _self;
  final $Res Function(_SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profile = freezed,Object? template = null,Object? customTemplates = null,Object? interval = null,Object? analysisEnabled = null,Object? model = null,Object? language = null,Object? analysisLanguage = null,Object? uiLocale = null,}) {
  return _then(_SettingsState(
profile: freezed == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as ProviderProfile?,template: null == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as AnalysisTemplate,customTemplates: null == customTemplates ? _self._customTemplates : customTemplates // ignore: cast_nullable_to_non_nullable
as List<AnalysisTemplate>,interval: null == interval ? _self.interval : interval // ignore: cast_nullable_to_non_nullable
as int,analysisEnabled: null == analysisEnabled ? _self.analysisEnabled : analysisEnabled // ignore: cast_nullable_to_non_nullable
as bool,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,analysisLanguage: null == analysisLanguage ? _self.analysisLanguage : analysisLanguage // ignore: cast_nullable_to_non_nullable
as String,uiLocale: null == uiLocale ? _self.uiLocale : uiLocale // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProviderProfileCopyWith<$Res>? get profile {
    if (_self.profile == null) {
    return null;
  }

  return $ProviderProfileCopyWith<$Res>(_self.profile!, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalysisTemplateCopyWith<$Res> get template {
  
  return $AnalysisTemplateCopyWith<$Res>(_self.template, (value) {
    return _then(_self.copyWith(template: value));
  });
}
}

// dart format on

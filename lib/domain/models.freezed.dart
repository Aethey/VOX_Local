// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'models.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecordingSummary {

 String get id; DateTime get createdAt; DateTime get updatedAt; String get title; String get preview; int get segmentCount; double get duration; RecordingStatus get status; String get language; String get model; bool get analysisEnabled; ProviderProfile? get analysisProfile; AnalysisTemplate? get analysisTemplate;
/// Create a copy of RecordingSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecordingSummaryCopyWith<RecordingSummary> get copyWith => _$RecordingSummaryCopyWithImpl<RecordingSummary>(this as RecordingSummary, _$identity);

  /// Serializes this RecordingSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as RecordingSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecordingSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.updatedAt, _this.updatedAt) || other.updatedAt == _this.updatedAt)&&(identical(other.title, _this.title) || other.title == _this.title)&&(identical(other.preview, _this.preview) || other.preview == _this.preview)&&(identical(other.segmentCount, _this.segmentCount) || other.segmentCount == _this.segmentCount)&&(identical(other.duration, _this.duration) || other.duration == _this.duration)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.model, _this.model) || other.model == _this.model)&&(identical(other.analysisEnabled, _this.analysisEnabled) || other.analysisEnabled == _this.analysisEnabled)&&(identical(other.analysisProfile, _this.analysisProfile) || other.analysisProfile == _this.analysisProfile)&&(identical(other.analysisTemplate, _this.analysisTemplate) || other.analysisTemplate == _this.analysisTemplate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as RecordingSummary;
  return Object.hash(runtimeType,_this.id,_this.createdAt,_this.updatedAt,_this.title,_this.preview,_this.segmentCount,_this.duration,_this.status,_this.language,_this.model,_this.analysisEnabled,_this.analysisProfile,_this.analysisTemplate);
}

@override
String toString() {
  final _this = this as RecordingSummary;
  return 'RecordingSummary(id: ${_this.id}, createdAt: ${_this.createdAt}, updatedAt: ${_this.updatedAt}, title: ${_this.title}, preview: ${_this.preview}, segmentCount: ${_this.segmentCount}, duration: ${_this.duration}, status: ${_this.status}, language: ${_this.language}, model: ${_this.model}, analysisEnabled: ${_this.analysisEnabled}, analysisProfile: ${_this.analysisProfile}, analysisTemplate: ${_this.analysisTemplate})';
}


}

/// @nodoc
abstract mixin class $RecordingSummaryCopyWith<$Res>  {
  factory $RecordingSummaryCopyWith(RecordingSummary value, $Res Function(RecordingSummary) _then) = _$RecordingSummaryCopyWithImpl;
@useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt, String title, String preview, int segmentCount, double duration, RecordingStatus status, String language, String model, bool analysisEnabled, ProviderProfile? analysisProfile, AnalysisTemplate? analysisTemplate
});


$ProviderProfileCopyWith<$Res>? get analysisProfile;$AnalysisTemplateCopyWith<$Res>? get analysisTemplate;

}
/// @nodoc
class _$RecordingSummaryCopyWithImpl<$Res>
    implements $RecordingSummaryCopyWith<$Res> {
  _$RecordingSummaryCopyWithImpl(this._self, this._then);

  final RecordingSummary _self;
  final $Res Function(RecordingSummary) _then;

/// Create a copy of RecordingSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? title = null,Object? preview = null,Object? segmentCount = null,Object? duration = null,Object? status = null,Object? language = null,Object? model = null,Object? analysisEnabled = null,Object? analysisProfile = freezed,Object? analysisTemplate = freezed,}) {
  return _then(RecordingSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as String,segmentCount: null == segmentCount ? _self.segmentCount : segmentCount // ignore: cast_nullable_to_non_nullable
as int,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecordingStatus,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,analysisEnabled: null == analysisEnabled ? _self.analysisEnabled : analysisEnabled // ignore: cast_nullable_to_non_nullable
as bool,analysisProfile: freezed == analysisProfile ? _self.analysisProfile : analysisProfile // ignore: cast_nullable_to_non_nullable
as ProviderProfile?,analysisTemplate: freezed == analysisTemplate ? _self.analysisTemplate : analysisTemplate // ignore: cast_nullable_to_non_nullable
as AnalysisTemplate?,
  ));
}
/// Create a copy of RecordingSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProviderProfileCopyWith<$Res>? get analysisProfile {
    if (_self.analysisProfile == null) {
    return null;
  }

  return $ProviderProfileCopyWith<$Res>(_self.analysisProfile!, (value) {
    return _then(_self.copyWith(analysisProfile: value));
  });
}/// Create a copy of RecordingSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalysisTemplateCopyWith<$Res>? get analysisTemplate {
    if (_self.analysisTemplate == null) {
    return null;
  }

  return $AnalysisTemplateCopyWith<$Res>(_self.analysisTemplate!, (value) {
    return _then(_self.copyWith(analysisTemplate: value));
  });
}
}


/// Adds pattern-matching-related methods to [RecordingSummary].
extension RecordingSummaryPatterns on RecordingSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecordingSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecordingSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecordingSummary value)  $default,){
final _that = this;
switch (_that) {
case _RecordingSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecordingSummary value)?  $default,){
final _that = this;
switch (_that) {
case _RecordingSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime updatedAt,  String title,  String preview,  int segmentCount,  double duration,  RecordingStatus status,  String language,  String model,  bool analysisEnabled,  ProviderProfile? analysisProfile,  AnalysisTemplate? analysisTemplate)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecordingSummary() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.title,_that.preview,_that.segmentCount,_that.duration,_that.status,_that.language,_that.model,_that.analysisEnabled,_that.analysisProfile,_that.analysisTemplate);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  DateTime createdAt,  DateTime updatedAt,  String title,  String preview,  int segmentCount,  double duration,  RecordingStatus status,  String language,  String model,  bool analysisEnabled,  ProviderProfile? analysisProfile,  AnalysisTemplate? analysisTemplate)  $default,) {final _that = this;
switch (_that) {
case _RecordingSummary():
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.title,_that.preview,_that.segmentCount,_that.duration,_that.status,_that.language,_that.model,_that.analysisEnabled,_that.analysisProfile,_that.analysisTemplate);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  DateTime createdAt,  DateTime updatedAt,  String title,  String preview,  int segmentCount,  double duration,  RecordingStatus status,  String language,  String model,  bool analysisEnabled,  ProviderProfile? analysisProfile,  AnalysisTemplate? analysisTemplate)?  $default,) {final _that = this;
switch (_that) {
case _RecordingSummary() when $default != null:
return $default(_that.id,_that.createdAt,_that.updatedAt,_that.title,_that.preview,_that.segmentCount,_that.duration,_that.status,_that.language,_that.model,_that.analysisEnabled,_that.analysisProfile,_that.analysisTemplate);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _RecordingSummary extends RecordingSummary {
  const _RecordingSummary({required this.id, required this.createdAt, required this.updatedAt, this.title = '', this.preview = '', this.segmentCount = 0, this.duration = 0.0, this.status = RecordingStatus.completed, this.language = '', this.model = '', this.analysisEnabled = false, this.analysisProfile, this.analysisTemplate}): super._();
  factory _RecordingSummary.fromJson(Map<String, dynamic> json) => _$RecordingSummaryFromJson(json);

@override final  String id;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  String title;
@override@JsonKey() final  String preview;
@override@JsonKey() final  int segmentCount;
@override@JsonKey() final  double duration;
@override@JsonKey() final  RecordingStatus status;
@override@JsonKey() final  String language;
@override@JsonKey() final  String model;
@override@JsonKey() final  bool analysisEnabled;
@override final  ProviderProfile? analysisProfile;
@override final  AnalysisTemplate? analysisTemplate;

/// Create a copy of RecordingSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecordingSummaryCopyWith<_RecordingSummary> get copyWith => __$RecordingSummaryCopyWithImpl<_RecordingSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$RecordingSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecordingSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.title, title) || other.title == title)&&(identical(other.preview, preview) || other.preview == preview)&&(identical(other.segmentCount, segmentCount) || other.segmentCount == segmentCount)&&(identical(other.duration, duration) || other.duration == duration)&&(identical(other.status, status) || other.status == status)&&(identical(other.language, language) || other.language == language)&&(identical(other.model, model) || other.model == model)&&(identical(other.analysisEnabled, analysisEnabled) || other.analysisEnabled == analysisEnabled)&&(identical(other.analysisProfile, analysisProfile) || other.analysisProfile == analysisProfile)&&(identical(other.analysisTemplate, analysisTemplate) || other.analysisTemplate == analysisTemplate));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,createdAt,updatedAt,title,preview,segmentCount,duration,status,language,model,analysisEnabled,analysisProfile,analysisTemplate);
}

@override
String toString() {
    return 'RecordingSummary(id: $id, createdAt: $createdAt, updatedAt: $updatedAt, title: $title, preview: $preview, segmentCount: $segmentCount, duration: $duration, status: $status, language: $language, model: $model, analysisEnabled: $analysisEnabled, analysisProfile: $analysisProfile, analysisTemplate: $analysisTemplate)';
}


}

/// @nodoc
abstract mixin class _$RecordingSummaryCopyWith<$Res> implements $RecordingSummaryCopyWith<$Res> {
  factory _$RecordingSummaryCopyWith(_RecordingSummary value, $Res Function(_RecordingSummary) _then) = __$RecordingSummaryCopyWithImpl;
@override @useResult
$Res call({
 String id, DateTime createdAt, DateTime updatedAt, String title, String preview, int segmentCount, double duration, RecordingStatus status, String language, String model, bool analysisEnabled, ProviderProfile? analysisProfile, AnalysisTemplate? analysisTemplate
});


@override $ProviderProfileCopyWith<$Res>? get analysisProfile;@override $AnalysisTemplateCopyWith<$Res>? get analysisTemplate;

}
/// @nodoc
class __$RecordingSummaryCopyWithImpl<$Res>
    implements _$RecordingSummaryCopyWith<$Res> {
  __$RecordingSummaryCopyWithImpl(this._self, this._then);

  final _RecordingSummary _self;
  final $Res Function(_RecordingSummary) _then;

/// Create a copy of RecordingSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? createdAt = null,Object? updatedAt = null,Object? title = null,Object? preview = null,Object? segmentCount = null,Object? duration = null,Object? status = null,Object? language = null,Object? model = null,Object? analysisEnabled = null,Object? analysisProfile = freezed,Object? analysisTemplate = freezed,}) {
  return _then(_RecordingSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,preview: null == preview ? _self.preview : preview // ignore: cast_nullable_to_non_nullable
as String,segmentCount: null == segmentCount ? _self.segmentCount : segmentCount // ignore: cast_nullable_to_non_nullable
as int,duration: null == duration ? _self.duration : duration // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecordingStatus,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,analysisEnabled: null == analysisEnabled ? _self.analysisEnabled : analysisEnabled // ignore: cast_nullable_to_non_nullable
as bool,analysisProfile: freezed == analysisProfile ? _self.analysisProfile : analysisProfile // ignore: cast_nullable_to_non_nullable
as ProviderProfile?,analysisTemplate: freezed == analysisTemplate ? _self.analysisTemplate : analysisTemplate // ignore: cast_nullable_to_non_nullable
as AnalysisTemplate?,
  ));
}

/// Create a copy of RecordingSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProviderProfileCopyWith<$Res>? get analysisProfile {
    if (_self.analysisProfile == null) {
    return null;
  }

  return $ProviderProfileCopyWith<$Res>(_self.analysisProfile!, (value) {
    return _then(_self.copyWith(analysisProfile: value));
  });
}/// Create a copy of RecordingSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalysisTemplateCopyWith<$Res>? get analysisTemplate {
    if (_self.analysisTemplate == null) {
    return null;
  }

  return $AnalysisTemplateCopyWith<$Res>(_self.analysisTemplate!, (value) {
    return _then(_self.copyWith(analysisTemplate: value));
  });
}
}


/// @nodoc
mixin _$TranscriptSegment {

 String get id; String get sessionId; int get sequence; double get start; double get end; String get text;
/// Create a copy of TranscriptSegment
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TranscriptSegmentCopyWith<TranscriptSegment> get copyWith => _$TranscriptSegmentCopyWithImpl<TranscriptSegment>(this as TranscriptSegment, _$identity);

  /// Serializes this TranscriptSegment to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as TranscriptSegment;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TranscriptSegment&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.sessionId, _this.sessionId) || other.sessionId == _this.sessionId)&&(identical(other.sequence, _this.sequence) || other.sequence == _this.sequence)&&(identical(other.start, _this.start) || other.start == _this.start)&&(identical(other.end, _this.end) || other.end == _this.end)&&(identical(other.text, _this.text) || other.text == _this.text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as TranscriptSegment;
  return Object.hash(runtimeType,_this.id,_this.sessionId,_this.sequence,_this.start,_this.end,_this.text);
}

@override
String toString() {
  final _this = this as TranscriptSegment;
  return 'TranscriptSegment(id: ${_this.id}, sessionId: ${_this.sessionId}, sequence: ${_this.sequence}, start: ${_this.start}, end: ${_this.end}, text: ${_this.text})';
}


}

/// @nodoc
abstract mixin class $TranscriptSegmentCopyWith<$Res>  {
  factory $TranscriptSegmentCopyWith(TranscriptSegment value, $Res Function(TranscriptSegment) _then) = _$TranscriptSegmentCopyWithImpl;
@useResult
$Res call({
 String id, String sessionId, int sequence, double start, double end, String text
});




}
/// @nodoc
class _$TranscriptSegmentCopyWithImpl<$Res>
    implements $TranscriptSegmentCopyWith<$Res> {
  _$TranscriptSegmentCopyWithImpl(this._self, this._then);

  final TranscriptSegment _self;
  final $Res Function(TranscriptSegment) _then;

/// Create a copy of TranscriptSegment
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? sequence = null,Object? start = null,Object? end = null,Object? text = null,}) {
  return _then(TranscriptSegment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as double,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as double,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [TranscriptSegment].
extension TranscriptSegmentPatterns on TranscriptSegment {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TranscriptSegment value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TranscriptSegment() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TranscriptSegment value)  $default,){
final _that = this;
switch (_that) {
case _TranscriptSegment():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TranscriptSegment value)?  $default,){
final _that = this;
switch (_that) {
case _TranscriptSegment() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sessionId,  int sequence,  double start,  double end,  String text)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TranscriptSegment() when $default != null:
return $default(_that.id,_that.sessionId,_that.sequence,_that.start,_that.end,_that.text);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sessionId,  int sequence,  double start,  double end,  String text)  $default,) {final _that = this;
switch (_that) {
case _TranscriptSegment():
return $default(_that.id,_that.sessionId,_that.sequence,_that.start,_that.end,_that.text);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sessionId,  int sequence,  double start,  double end,  String text)?  $default,) {final _that = this;
switch (_that) {
case _TranscriptSegment() when $default != null:
return $default(_that.id,_that.sessionId,_that.sequence,_that.start,_that.end,_that.text);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _TranscriptSegment implements TranscriptSegment {
  const _TranscriptSegment({required this.id, required this.sessionId, required this.sequence, required this.start, required this.end, required this.text});
  factory _TranscriptSegment.fromJson(Map<String, dynamic> json) => _$TranscriptSegmentFromJson(json);

@override final  String id;
@override final  String sessionId;
@override final  int sequence;
@override final  double start;
@override final  double end;
@override final  String text;

/// Create a copy of TranscriptSegment
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TranscriptSegmentCopyWith<_TranscriptSegment> get copyWith => __$TranscriptSegmentCopyWithImpl<_TranscriptSegment>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$TranscriptSegmentToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _TranscriptSegment&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.sequence, sequence) || other.sequence == sequence)&&(identical(other.start, start) || other.start == start)&&(identical(other.end, end) || other.end == end)&&(identical(other.text, text) || other.text == text));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,sessionId,sequence,start,end,text);
}

@override
String toString() {
    return 'TranscriptSegment(id: $id, sessionId: $sessionId, sequence: $sequence, start: $start, end: $end, text: $text)';
}


}

/// @nodoc
abstract mixin class _$TranscriptSegmentCopyWith<$Res> implements $TranscriptSegmentCopyWith<$Res> {
  factory _$TranscriptSegmentCopyWith(_TranscriptSegment value, $Res Function(_TranscriptSegment) _then) = __$TranscriptSegmentCopyWithImpl;
@override @useResult
$Res call({
 String id, String sessionId, int sequence, double start, double end, String text
});




}
/// @nodoc
class __$TranscriptSegmentCopyWithImpl<$Res>
    implements _$TranscriptSegmentCopyWith<$Res> {
  __$TranscriptSegmentCopyWithImpl(this._self, this._then);

  final _TranscriptSegment _self;
  final $Res Function(_TranscriptSegment) _then;

/// Create a copy of TranscriptSegment
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? sequence = null,Object? start = null,Object? end = null,Object? text = null,}) {
  return _then(_TranscriptSegment(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,sequence: null == sequence ? _self.sequence : sequence // ignore: cast_nullable_to_non_nullable
as int,start: null == start ? _self.start : start // ignore: cast_nullable_to_non_nullable
as double,end: null == end ? _self.end : end // ignore: cast_nullable_to_non_nullable
as double,text: null == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$AnalysisTemplate {

 String get id; String get name; String get instruction; int get version; bool get preset;
/// Create a copy of AnalysisTemplate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalysisTemplateCopyWith<AnalysisTemplate> get copyWith => _$AnalysisTemplateCopyWithImpl<AnalysisTemplate>(this as AnalysisTemplate, _$identity);

  /// Serializes this AnalysisTemplate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AnalysisTemplate;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalysisTemplate&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.instruction, _this.instruction) || other.instruction == _this.instruction)&&(identical(other.version, _this.version) || other.version == _this.version)&&(identical(other.preset, _this.preset) || other.preset == _this.preset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AnalysisTemplate;
  return Object.hash(runtimeType,_this.id,_this.name,_this.instruction,_this.version,_this.preset);
}

@override
String toString() {
  final _this = this as AnalysisTemplate;
  return 'AnalysisTemplate(id: ${_this.id}, name: ${_this.name}, instruction: ${_this.instruction}, version: ${_this.version}, preset: ${_this.preset})';
}


}

/// @nodoc
abstract mixin class $AnalysisTemplateCopyWith<$Res>  {
  factory $AnalysisTemplateCopyWith(AnalysisTemplate value, $Res Function(AnalysisTemplate) _then) = _$AnalysisTemplateCopyWithImpl;
@useResult
$Res call({
 String id, String name, String instruction, int version, bool preset
});




}
/// @nodoc
class _$AnalysisTemplateCopyWithImpl<$Res>
    implements $AnalysisTemplateCopyWith<$Res> {
  _$AnalysisTemplateCopyWithImpl(this._self, this._then);

  final AnalysisTemplate _self;
  final $Res Function(AnalysisTemplate) _then;

/// Create a copy of AnalysisTemplate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? instruction = null,Object? version = null,Object? preset = null,}) {
  return _then(AnalysisTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,instruction: null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,preset: null == preset ? _self.preset : preset // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalysisTemplate].
extension AnalysisTemplatePatterns on AnalysisTemplate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalysisTemplate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalysisTemplate() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalysisTemplate value)  $default,){
final _that = this;
switch (_that) {
case _AnalysisTemplate():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalysisTemplate value)?  $default,){
final _that = this;
switch (_that) {
case _AnalysisTemplate() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String name,  String instruction,  int version,  bool preset)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalysisTemplate() when $default != null:
return $default(_that.id,_that.name,_that.instruction,_that.version,_that.preset);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String name,  String instruction,  int version,  bool preset)  $default,) {final _that = this;
switch (_that) {
case _AnalysisTemplate():
return $default(_that.id,_that.name,_that.instruction,_that.version,_that.preset);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String name,  String instruction,  int version,  bool preset)?  $default,) {final _that = this;
switch (_that) {
case _AnalysisTemplate() when $default != null:
return $default(_that.id,_that.name,_that.instruction,_that.version,_that.preset);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalysisTemplate implements AnalysisTemplate {
  const _AnalysisTemplate({required this.id, required this.name, required this.instruction, this.version = 1, this.preset = false});
  factory _AnalysisTemplate.fromJson(Map<String, dynamic> json) => _$AnalysisTemplateFromJson(json);

@override final  String id;
@override final  String name;
@override final  String instruction;
@override@JsonKey() final  int version;
@override@JsonKey() final  bool preset;

/// Create a copy of AnalysisTemplate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalysisTemplateCopyWith<_AnalysisTemplate> get copyWith => __$AnalysisTemplateCopyWithImpl<_AnalysisTemplate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalysisTemplateToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalysisTemplate&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.instruction, instruction) || other.instruction == instruction)&&(identical(other.version, version) || other.version == version)&&(identical(other.preset, preset) || other.preset == preset));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,instruction,version,preset);
}

@override
String toString() {
    return 'AnalysisTemplate(id: $id, name: $name, instruction: $instruction, version: $version, preset: $preset)';
}


}

/// @nodoc
abstract mixin class _$AnalysisTemplateCopyWith<$Res> implements $AnalysisTemplateCopyWith<$Res> {
  factory _$AnalysisTemplateCopyWith(_AnalysisTemplate value, $Res Function(_AnalysisTemplate) _then) = __$AnalysisTemplateCopyWithImpl;
@override @useResult
$Res call({
 String id, String name, String instruction, int version, bool preset
});




}
/// @nodoc
class __$AnalysisTemplateCopyWithImpl<$Res>
    implements _$AnalysisTemplateCopyWith<$Res> {
  __$AnalysisTemplateCopyWithImpl(this._self, this._then);

  final _AnalysisTemplate _self;
  final $Res Function(_AnalysisTemplate) _then;

/// Create a copy of AnalysisTemplate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? instruction = null,Object? version = null,Object? preset = null,}) {
  return _then(_AnalysisTemplate(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,instruction: null == instruction ? _self.instruction : instruction // ignore: cast_nullable_to_non_nullable
as String,version: null == version ? _self.version : version // ignore: cast_nullable_to_non_nullable
as int,preset: null == preset ? _self.preset : preset // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}


/// @nodoc
mixin _$ProviderProfile {

 String get id; String get provider; String get endpoint; String get model; String get credentialRef; int get inputCharacters; int get maxOutputTokens;
/// Create a copy of ProviderProfile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProviderProfileCopyWith<ProviderProfile> get copyWith => _$ProviderProfileCopyWithImpl<ProviderProfile>(this as ProviderProfile, _$identity);

  /// Serializes this ProviderProfile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProviderProfile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProviderProfile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.provider, _this.provider) || other.provider == _this.provider)&&(identical(other.endpoint, _this.endpoint) || other.endpoint == _this.endpoint)&&(identical(other.model, _this.model) || other.model == _this.model)&&(identical(other.credentialRef, _this.credentialRef) || other.credentialRef == _this.credentialRef)&&(identical(other.inputCharacters, _this.inputCharacters) || other.inputCharacters == _this.inputCharacters)&&(identical(other.maxOutputTokens, _this.maxOutputTokens) || other.maxOutputTokens == _this.maxOutputTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProviderProfile;
  return Object.hash(runtimeType,_this.id,_this.provider,_this.endpoint,_this.model,_this.credentialRef,_this.inputCharacters,_this.maxOutputTokens);
}

@override
String toString() {
  final _this = this as ProviderProfile;
  return 'ProviderProfile(id: ${_this.id}, provider: ${_this.provider}, endpoint: ${_this.endpoint}, model: ${_this.model}, credentialRef: ${_this.credentialRef}, inputCharacters: ${_this.inputCharacters}, maxOutputTokens: ${_this.maxOutputTokens})';
}


}

/// @nodoc
abstract mixin class $ProviderProfileCopyWith<$Res>  {
  factory $ProviderProfileCopyWith(ProviderProfile value, $Res Function(ProviderProfile) _then) = _$ProviderProfileCopyWithImpl;
@useResult
$Res call({
 String id, String provider, String endpoint, String model, String credentialRef, int inputCharacters, int maxOutputTokens
});




}
/// @nodoc
class _$ProviderProfileCopyWithImpl<$Res>
    implements $ProviderProfileCopyWith<$Res> {
  _$ProviderProfileCopyWithImpl(this._self, this._then);

  final ProviderProfile _self;
  final $Res Function(ProviderProfile) _then;

/// Create a copy of ProviderProfile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? provider = null,Object? endpoint = null,Object? model = null,Object? credentialRef = null,Object? inputCharacters = null,Object? maxOutputTokens = null,}) {
  return _then(ProviderProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,endpoint: null == endpoint ? _self.endpoint : endpoint // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,credentialRef: null == credentialRef ? _self.credentialRef : credentialRef // ignore: cast_nullable_to_non_nullable
as String,inputCharacters: null == inputCharacters ? _self.inputCharacters : inputCharacters // ignore: cast_nullable_to_non_nullable
as int,maxOutputTokens: null == maxOutputTokens ? _self.maxOutputTokens : maxOutputTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ProviderProfile].
extension ProviderProfilePatterns on ProviderProfile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProviderProfile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProviderProfile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProviderProfile value)  $default,){
final _that = this;
switch (_that) {
case _ProviderProfile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProviderProfile value)?  $default,){
final _that = this;
switch (_that) {
case _ProviderProfile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String provider,  String endpoint,  String model,  String credentialRef,  int inputCharacters,  int maxOutputTokens)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProviderProfile() when $default != null:
return $default(_that.id,_that.provider,_that.endpoint,_that.model,_that.credentialRef,_that.inputCharacters,_that.maxOutputTokens);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String provider,  String endpoint,  String model,  String credentialRef,  int inputCharacters,  int maxOutputTokens)  $default,) {final _that = this;
switch (_that) {
case _ProviderProfile():
return $default(_that.id,_that.provider,_that.endpoint,_that.model,_that.credentialRef,_that.inputCharacters,_that.maxOutputTokens);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String provider,  String endpoint,  String model,  String credentialRef,  int inputCharacters,  int maxOutputTokens)?  $default,) {final _that = this;
switch (_that) {
case _ProviderProfile() when $default != null:
return $default(_that.id,_that.provider,_that.endpoint,_that.model,_that.credentialRef,_that.inputCharacters,_that.maxOutputTokens);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProviderProfile extends ProviderProfile {
  const _ProviderProfile({required this.id, required this.provider, required this.endpoint, required this.model, required this.credentialRef, this.inputCharacters = 12000, this.maxOutputTokens = 1500}): super._();
  factory _ProviderProfile.fromJson(Map<String, dynamic> json) => _$ProviderProfileFromJson(json);

@override final  String id;
@override final  String provider;
@override final  String endpoint;
@override final  String model;
@override final  String credentialRef;
@override@JsonKey() final  int inputCharacters;
@override@JsonKey() final  int maxOutputTokens;

/// Create a copy of ProviderProfile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProviderProfileCopyWith<_ProviderProfile> get copyWith => __$ProviderProfileCopyWithImpl<_ProviderProfile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProviderProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProviderProfile&&(identical(other.id, id) || other.id == id)&&(identical(other.provider, provider) || other.provider == provider)&&(identical(other.endpoint, endpoint) || other.endpoint == endpoint)&&(identical(other.model, model) || other.model == model)&&(identical(other.credentialRef, credentialRef) || other.credentialRef == credentialRef)&&(identical(other.inputCharacters, inputCharacters) || other.inputCharacters == inputCharacters)&&(identical(other.maxOutputTokens, maxOutputTokens) || other.maxOutputTokens == maxOutputTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,provider,endpoint,model,credentialRef,inputCharacters,maxOutputTokens);
}

@override
String toString() {
    return 'ProviderProfile(id: $id, provider: $provider, endpoint: $endpoint, model: $model, credentialRef: $credentialRef, inputCharacters: $inputCharacters, maxOutputTokens: $maxOutputTokens)';
}


}

/// @nodoc
abstract mixin class _$ProviderProfileCopyWith<$Res> implements $ProviderProfileCopyWith<$Res> {
  factory _$ProviderProfileCopyWith(_ProviderProfile value, $Res Function(_ProviderProfile) _then) = __$ProviderProfileCopyWithImpl;
@override @useResult
$Res call({
 String id, String provider, String endpoint, String model, String credentialRef, int inputCharacters, int maxOutputTokens
});




}
/// @nodoc
class __$ProviderProfileCopyWithImpl<$Res>
    implements _$ProviderProfileCopyWith<$Res> {
  __$ProviderProfileCopyWithImpl(this._self, this._then);

  final _ProviderProfile _self;
  final $Res Function(_ProviderProfile) _then;

/// Create a copy of ProviderProfile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? provider = null,Object? endpoint = null,Object? model = null,Object? credentialRef = null,Object? inputCharacters = null,Object? maxOutputTokens = null,}) {
  return _then(_ProviderProfile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,provider: null == provider ? _self.provider : provider // ignore: cast_nullable_to_non_nullable
as String,endpoint: null == endpoint ? _self.endpoint : endpoint // ignore: cast_nullable_to_non_nullable
as String,model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,credentialRef: null == credentialRef ? _self.credentialRef : credentialRef // ignore: cast_nullable_to_non_nullable
as String,inputCharacters: null == inputCharacters ? _self.inputCharacters : inputCharacters // ignore: cast_nullable_to_non_nullable
as int,maxOutputTokens: null == maxOutputTokens ? _self.maxOutputTokens : maxOutputTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}


/// @nodoc
mixin _$AnalysisJob {

 String get id; String get sessionId; ProviderProfile get profile; AnalysisTemplate get template; List<TranscriptSegment> get segments; String get context; DateTime get createdAt;/// Language the provider is asked to write findings in.
 String get language;/// True when the job carries the full transcript in one request
/// (manual re-analysis) instead of an incremental batch.
 bool get whole; JobPhase get phase; int get attempts; DateTime? get scheduledAt; String? get error; AnalysisResult? get result;
/// Create a copy of AnalysisJob
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalysisJobCopyWith<AnalysisJob> get copyWith => _$AnalysisJobCopyWithImpl<AnalysisJob>(this as AnalysisJob, _$identity);

  /// Serializes this AnalysisJob to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AnalysisJob;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalysisJob&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.sessionId, _this.sessionId) || other.sessionId == _this.sessionId)&&(identical(other.profile, _this.profile) || other.profile == _this.profile)&&(identical(other.template, _this.template) || other.template == _this.template)&&const DeepCollectionEquality().equals(other.segments, _this.segments)&&(identical(other.context, _this.context) || other.context == _this.context)&&(identical(other.createdAt, _this.createdAt) || other.createdAt == _this.createdAt)&&(identical(other.language, _this.language) || other.language == _this.language)&&(identical(other.whole, _this.whole) || other.whole == _this.whole)&&(identical(other.phase, _this.phase) || other.phase == _this.phase)&&(identical(other.attempts, _this.attempts) || other.attempts == _this.attempts)&&(identical(other.scheduledAt, _this.scheduledAt) || other.scheduledAt == _this.scheduledAt)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.result, _this.result) || other.result == _this.result));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AnalysisJob;
  return Object.hash(runtimeType,_this.id,_this.sessionId,_this.profile,_this.template,const DeepCollectionEquality().hash(_this.segments),_this.context,_this.createdAt,_this.language,_this.whole,_this.phase,_this.attempts,_this.scheduledAt,_this.error,_this.result);
}

@override
String toString() {
  final _this = this as AnalysisJob;
  return 'AnalysisJob(id: ${_this.id}, sessionId: ${_this.sessionId}, profile: ${_this.profile}, template: ${_this.template}, segments: ${_this.segments}, context: ${_this.context}, createdAt: ${_this.createdAt}, language: ${_this.language}, whole: ${_this.whole}, phase: ${_this.phase}, attempts: ${_this.attempts}, scheduledAt: ${_this.scheduledAt}, error: ${_this.error}, result: ${_this.result})';
}


}

/// @nodoc
abstract mixin class $AnalysisJobCopyWith<$Res>  {
  factory $AnalysisJobCopyWith(AnalysisJob value, $Res Function(AnalysisJob) _then) = _$AnalysisJobCopyWithImpl;
@useResult
$Res call({
 String id, String sessionId, ProviderProfile profile, AnalysisTemplate template, List<TranscriptSegment> segments, String context, DateTime createdAt, String language, bool whole, JobPhase phase, int attempts, DateTime? scheduledAt, String? error, AnalysisResult? result
});


$ProviderProfileCopyWith<$Res> get profile;$AnalysisTemplateCopyWith<$Res> get template;$AnalysisResultCopyWith<$Res>? get result;

}
/// @nodoc
class _$AnalysisJobCopyWithImpl<$Res>
    implements $AnalysisJobCopyWith<$Res> {
  _$AnalysisJobCopyWithImpl(this._self, this._then);

  final AnalysisJob _self;
  final $Res Function(AnalysisJob) _then;

/// Create a copy of AnalysisJob
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? sessionId = null,Object? profile = null,Object? template = null,Object? segments = null,Object? context = null,Object? createdAt = null,Object? language = null,Object? whole = null,Object? phase = null,Object? attempts = null,Object? scheduledAt = freezed,Object? error = freezed,Object? result = freezed,}) {
  return _then(AnalysisJob(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as ProviderProfile,template: null == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as AnalysisTemplate,segments: null == segments ? _self.segments : segments // ignore: cast_nullable_to_non_nullable
as List<TranscriptSegment>,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,whole: null == whole ? _self.whole : whole // ignore: cast_nullable_to_non_nullable
as bool,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as JobPhase,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as AnalysisResult?,
  ));
}
/// Create a copy of AnalysisJob
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProviderProfileCopyWith<$Res> get profile {
  
  return $ProviderProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of AnalysisJob
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalysisTemplateCopyWith<$Res> get template {
  
  return $AnalysisTemplateCopyWith<$Res>(_self.template, (value) {
    return _then(_self.copyWith(template: value));
  });
}/// Create a copy of AnalysisJob
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalysisResultCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $AnalysisResultCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// Adds pattern-matching-related methods to [AnalysisJob].
extension AnalysisJobPatterns on AnalysisJob {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalysisJob value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalysisJob() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalysisJob value)  $default,){
final _that = this;
switch (_that) {
case _AnalysisJob():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalysisJob value)?  $default,){
final _that = this;
switch (_that) {
case _AnalysisJob() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String sessionId,  ProviderProfile profile,  AnalysisTemplate template,  List<TranscriptSegment> segments,  String context,  DateTime createdAt,  String language,  bool whole,  JobPhase phase,  int attempts,  DateTime? scheduledAt,  String? error,  AnalysisResult? result)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalysisJob() when $default != null:
return $default(_that.id,_that.sessionId,_that.profile,_that.template,_that.segments,_that.context,_that.createdAt,_that.language,_that.whole,_that.phase,_that.attempts,_that.scheduledAt,_that.error,_that.result);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String sessionId,  ProviderProfile profile,  AnalysisTemplate template,  List<TranscriptSegment> segments,  String context,  DateTime createdAt,  String language,  bool whole,  JobPhase phase,  int attempts,  DateTime? scheduledAt,  String? error,  AnalysisResult? result)  $default,) {final _that = this;
switch (_that) {
case _AnalysisJob():
return $default(_that.id,_that.sessionId,_that.profile,_that.template,_that.segments,_that.context,_that.createdAt,_that.language,_that.whole,_that.phase,_that.attempts,_that.scheduledAt,_that.error,_that.result);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String sessionId,  ProviderProfile profile,  AnalysisTemplate template,  List<TranscriptSegment> segments,  String context,  DateTime createdAt,  String language,  bool whole,  JobPhase phase,  int attempts,  DateTime? scheduledAt,  String? error,  AnalysisResult? result)?  $default,) {final _that = this;
switch (_that) {
case _AnalysisJob() when $default != null:
return $default(_that.id,_that.sessionId,_that.profile,_that.template,_that.segments,_that.context,_that.createdAt,_that.language,_that.whole,_that.phase,_that.attempts,_that.scheduledAt,_that.error,_that.result);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalysisJob extends AnalysisJob {
  const _AnalysisJob({required this.id, required this.sessionId, required this.profile, required this.template, required  List<TranscriptSegment> segments, required this.context, required this.createdAt, this.language = 'zh', this.whole = false, this.phase = JobPhase.pending, this.attempts = 0, this.scheduledAt, this.error, this.result}): _segments = segments,super._();
  factory _AnalysisJob.fromJson(Map<String, dynamic> json) => _$AnalysisJobFromJson(json);

@override final  String id;
@override final  String sessionId;
@override final  ProviderProfile profile;
@override final  AnalysisTemplate template;
 final  List<TranscriptSegment> _segments;
@override List<TranscriptSegment> get segments {
  if (_segments is EqualUnmodifiableListView) return _segments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_segments);
}

@override final  String context;
@override final  DateTime createdAt;
/// Language the provider is asked to write findings in.
@override@JsonKey() final  String language;
/// True when the job carries the full transcript in one request
/// (manual re-analysis) instead of an incremental batch.
@override@JsonKey() final  bool whole;
@override@JsonKey() final  JobPhase phase;
@override@JsonKey() final  int attempts;
@override final  DateTime? scheduledAt;
@override final  String? error;
@override final  AnalysisResult? result;

/// Create a copy of AnalysisJob
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalysisJobCopyWith<_AnalysisJob> get copyWith => __$AnalysisJobCopyWithImpl<_AnalysisJob>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalysisJobToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalysisJob&&(identical(other.id, id) || other.id == id)&&(identical(other.sessionId, sessionId) || other.sessionId == sessionId)&&(identical(other.profile, profile) || other.profile == profile)&&(identical(other.template, template) || other.template == template)&&const DeepCollectionEquality().equals(other.segments, _segments)&&(identical(other.context, context) || other.context == context)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.language, language) || other.language == language)&&(identical(other.whole, whole) || other.whole == whole)&&(identical(other.phase, phase) || other.phase == phase)&&(identical(other.attempts, attempts) || other.attempts == attempts)&&(identical(other.scheduledAt, scheduledAt) || other.scheduledAt == scheduledAt)&&(identical(other.error, error) || other.error == error)&&(identical(other.result, result) || other.result == result));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,sessionId,profile,template,const DeepCollectionEquality().hash(_segments),context,createdAt,language,whole,phase,attempts,scheduledAt,error,result);
}

@override
String toString() {
    return 'AnalysisJob(id: $id, sessionId: $sessionId, profile: $profile, template: $template, segments: $segments, context: $context, createdAt: $createdAt, language: $language, whole: $whole, phase: $phase, attempts: $attempts, scheduledAt: $scheduledAt, error: $error, result: $result)';
}


}

/// @nodoc
abstract mixin class _$AnalysisJobCopyWith<$Res> implements $AnalysisJobCopyWith<$Res> {
  factory _$AnalysisJobCopyWith(_AnalysisJob value, $Res Function(_AnalysisJob) _then) = __$AnalysisJobCopyWithImpl;
@override @useResult
$Res call({
 String id, String sessionId, ProviderProfile profile, AnalysisTemplate template, List<TranscriptSegment> segments, String context, DateTime createdAt, String language, bool whole, JobPhase phase, int attempts, DateTime? scheduledAt, String? error, AnalysisResult? result
});


@override $ProviderProfileCopyWith<$Res> get profile;@override $AnalysisTemplateCopyWith<$Res> get template;@override $AnalysisResultCopyWith<$Res>? get result;

}
/// @nodoc
class __$AnalysisJobCopyWithImpl<$Res>
    implements _$AnalysisJobCopyWith<$Res> {
  __$AnalysisJobCopyWithImpl(this._self, this._then);

  final _AnalysisJob _self;
  final $Res Function(_AnalysisJob) _then;

/// Create a copy of AnalysisJob
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? sessionId = null,Object? profile = null,Object? template = null,Object? segments = null,Object? context = null,Object? createdAt = null,Object? language = null,Object? whole = null,Object? phase = null,Object? attempts = null,Object? scheduledAt = freezed,Object? error = freezed,Object? result = freezed,}) {
  return _then(_AnalysisJob(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,sessionId: null == sessionId ? _self.sessionId : sessionId // ignore: cast_nullable_to_non_nullable
as String,profile: null == profile ? _self.profile : profile // ignore: cast_nullable_to_non_nullable
as ProviderProfile,template: null == template ? _self.template : template // ignore: cast_nullable_to_non_nullable
as AnalysisTemplate,segments: null == segments ? _self._segments : segments // ignore: cast_nullable_to_non_nullable
as List<TranscriptSegment>,context: null == context ? _self.context : context // ignore: cast_nullable_to_non_nullable
as String,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,language: null == language ? _self.language : language // ignore: cast_nullable_to_non_nullable
as String,whole: null == whole ? _self.whole : whole // ignore: cast_nullable_to_non_nullable
as bool,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as JobPhase,attempts: null == attempts ? _self.attempts : attempts // ignore: cast_nullable_to_non_nullable
as int,scheduledAt: freezed == scheduledAt ? _self.scheduledAt : scheduledAt // ignore: cast_nullable_to_non_nullable
as DateTime?,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,result: freezed == result ? _self.result : result // ignore: cast_nullable_to_non_nullable
as AnalysisResult?,
  ));
}

/// Create a copy of AnalysisJob
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProviderProfileCopyWith<$Res> get profile {
  
  return $ProviderProfileCopyWith<$Res>(_self.profile, (value) {
    return _then(_self.copyWith(profile: value));
  });
}/// Create a copy of AnalysisJob
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalysisTemplateCopyWith<$Res> get template {
  
  return $AnalysisTemplateCopyWith<$Res>(_self.template, (value) {
    return _then(_self.copyWith(template: value));
  });
}/// Create a copy of AnalysisJob
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnalysisResultCopyWith<$Res>? get result {
    if (_self.result == null) {
    return null;
  }

  return $AnalysisResultCopyWith<$Res>(_self.result!, (value) {
    return _then(_self.copyWith(result: value));
  });
}
}


/// @nodoc
mixin _$Finding {

 String get topic; String get summary;@JsonKey(name: 'evidenceSegmentIds') List<String> get evidence; List<String> get questions;
/// Create a copy of Finding
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FindingCopyWith<Finding> get copyWith => _$FindingCopyWithImpl<Finding>(this as Finding, _$identity);

  /// Serializes this Finding to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Finding;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Finding&&(identical(other.topic, _this.topic) || other.topic == _this.topic)&&(identical(other.summary, _this.summary) || other.summary == _this.summary)&&const DeepCollectionEquality().equals(other.evidence, _this.evidence)&&const DeepCollectionEquality().equals(other.questions, _this.questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Finding;
  return Object.hash(runtimeType,_this.topic,_this.summary,const DeepCollectionEquality().hash(_this.evidence),const DeepCollectionEquality().hash(_this.questions));
}

@override
String toString() {
  final _this = this as Finding;
  return 'Finding(topic: ${_this.topic}, summary: ${_this.summary}, evidence: ${_this.evidence}, questions: ${_this.questions})';
}


}

/// @nodoc
abstract mixin class $FindingCopyWith<$Res>  {
  factory $FindingCopyWith(Finding value, $Res Function(Finding) _then) = _$FindingCopyWithImpl;
@useResult
$Res call({
 String topic, String summary,@JsonKey(name: 'evidenceSegmentIds') List<String> evidence, List<String> questions
});




}
/// @nodoc
class _$FindingCopyWithImpl<$Res>
    implements $FindingCopyWith<$Res> {
  _$FindingCopyWithImpl(this._self, this._then);

  final Finding _self;
  final $Res Function(Finding) _then;

/// Create a copy of Finding
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? topic = null,Object? summary = null,Object? evidence = null,Object? questions = null,}) {
  return _then(Finding(
topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,evidence: null == evidence ? _self.evidence : evidence // ignore: cast_nullable_to_non_nullable
as List<String>,questions: null == questions ? _self.questions : questions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [Finding].
extension FindingPatterns on Finding {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Finding value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Finding() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Finding value)  $default,){
final _that = this;
switch (_that) {
case _Finding():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Finding value)?  $default,){
final _that = this;
switch (_that) {
case _Finding() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String topic,  String summary, @JsonKey(name: 'evidenceSegmentIds')  List<String> evidence,  List<String> questions)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Finding() when $default != null:
return $default(_that.topic,_that.summary,_that.evidence,_that.questions);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String topic,  String summary, @JsonKey(name: 'evidenceSegmentIds')  List<String> evidence,  List<String> questions)  $default,) {final _that = this;
switch (_that) {
case _Finding():
return $default(_that.topic,_that.summary,_that.evidence,_that.questions);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String topic,  String summary, @JsonKey(name: 'evidenceSegmentIds')  List<String> evidence,  List<String> questions)?  $default,) {final _that = this;
switch (_that) {
case _Finding() when $default != null:
return $default(_that.topic,_that.summary,_that.evidence,_that.questions);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Finding implements Finding {
  const _Finding({required this.topic, required this.summary, @JsonKey(name: 'evidenceSegmentIds') required  List<String> evidence,  List<String> questions = const []}): _evidence = evidence,_questions = questions;
  factory _Finding.fromJson(Map<String, dynamic> json) => _$FindingFromJson(json);

@override final  String topic;
@override final  String summary;
 final  List<String> _evidence;
@override@JsonKey(name: 'evidenceSegmentIds') List<String> get evidence {
  if (_evidence is EqualUnmodifiableListView) return _evidence;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_evidence);
}

 final  List<String> _questions;
@override@JsonKey() List<String> get questions {
  if (_questions is EqualUnmodifiableListView) return _questions;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_questions);
}


/// Create a copy of Finding
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FindingCopyWith<_Finding> get copyWith => __$FindingCopyWithImpl<_Finding>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FindingToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Finding&&(identical(other.topic, topic) || other.topic == topic)&&(identical(other.summary, summary) || other.summary == summary)&&const DeepCollectionEquality().equals(other.evidence, _evidence)&&const DeepCollectionEquality().equals(other.questions, _questions));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,topic,summary,const DeepCollectionEquality().hash(_evidence),const DeepCollectionEquality().hash(_questions));
}

@override
String toString() {
    return 'Finding(topic: $topic, summary: $summary, evidence: $evidence, questions: $questions)';
}


}

/// @nodoc
abstract mixin class _$FindingCopyWith<$Res> implements $FindingCopyWith<$Res> {
  factory _$FindingCopyWith(_Finding value, $Res Function(_Finding) _then) = __$FindingCopyWithImpl;
@override @useResult
$Res call({
 String topic, String summary,@JsonKey(name: 'evidenceSegmentIds') List<String> evidence, List<String> questions
});




}
/// @nodoc
class __$FindingCopyWithImpl<$Res>
    implements _$FindingCopyWith<$Res> {
  __$FindingCopyWithImpl(this._self, this._then);

  final _Finding _self;
  final $Res Function(_Finding) _then;

/// Create a copy of Finding
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? topic = null,Object? summary = null,Object? evidence = null,Object? questions = null,}) {
  return _then(_Finding(
topic: null == topic ? _self.topic : topic // ignore: cast_nullable_to_non_nullable
as String,summary: null == summary ? _self.summary : summary // ignore: cast_nullable_to_non_nullable
as String,evidence: null == evidence ? _self._evidence : evidence // ignore: cast_nullable_to_non_nullable
as List<String>,questions: null == questions ? _self._questions : questions // ignore: cast_nullable_to_non_nullable
as List<String>,
  ));
}


}


/// @nodoc
mixin _$AnalysisResult {

 bool get matched; List<Finding> get findings;
/// Create a copy of AnalysisResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalysisResultCopyWith<AnalysisResult> get copyWith => _$AnalysisResultCopyWithImpl<AnalysisResult>(this as AnalysisResult, _$identity);

  /// Serializes this AnalysisResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as AnalysisResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalysisResult&&(identical(other.matched, _this.matched) || other.matched == _this.matched)&&const DeepCollectionEquality().equals(other.findings, _this.findings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as AnalysisResult;
  return Object.hash(runtimeType,_this.matched,const DeepCollectionEquality().hash(_this.findings));
}

@override
String toString() {
  final _this = this as AnalysisResult;
  return 'AnalysisResult(matched: ${_this.matched}, findings: ${_this.findings})';
}


}

/// @nodoc
abstract mixin class $AnalysisResultCopyWith<$Res>  {
  factory $AnalysisResultCopyWith(AnalysisResult value, $Res Function(AnalysisResult) _then) = _$AnalysisResultCopyWithImpl;
@useResult
$Res call({
 bool matched, List<Finding> findings
});




}
/// @nodoc
class _$AnalysisResultCopyWithImpl<$Res>
    implements $AnalysisResultCopyWith<$Res> {
  _$AnalysisResultCopyWithImpl(this._self, this._then);

  final AnalysisResult _self;
  final $Res Function(AnalysisResult) _then;

/// Create a copy of AnalysisResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? matched = null,Object? findings = null,}) {
  return _then(AnalysisResult(
matched: null == matched ? _self.matched : matched // ignore: cast_nullable_to_non_nullable
as bool,findings: null == findings ? _self.findings : findings // ignore: cast_nullable_to_non_nullable
as List<Finding>,
  ));
}

}


/// Adds pattern-matching-related methods to [AnalysisResult].
extension AnalysisResultPatterns on AnalysisResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalysisResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalysisResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalysisResult value)  $default,){
final _that = this;
switch (_that) {
case _AnalysisResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalysisResult value)?  $default,){
final _that = this;
switch (_that) {
case _AnalysisResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool matched,  List<Finding> findings)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalysisResult() when $default != null:
return $default(_that.matched,_that.findings);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool matched,  List<Finding> findings)  $default,) {final _that = this;
switch (_that) {
case _AnalysisResult():
return $default(_that.matched,_that.findings);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool matched,  List<Finding> findings)?  $default,) {final _that = this;
switch (_that) {
case _AnalysisResult() when $default != null:
return $default(_that.matched,_that.findings);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _AnalysisResult implements AnalysisResult {
  const _AnalysisResult({required this.matched, required  List<Finding> findings}): _findings = findings;
  factory _AnalysisResult.fromJson(Map<String, dynamic> json) => _$AnalysisResultFromJson(json);

@override final  bool matched;
 final  List<Finding> _findings;
@override List<Finding> get findings {
  if (_findings is EqualUnmodifiableListView) return _findings;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_findings);
}


/// Create a copy of AnalysisResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalysisResultCopyWith<_AnalysisResult> get copyWith => __$AnalysisResultCopyWithImpl<_AnalysisResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AnalysisResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalysisResult&&(identical(other.matched, matched) || other.matched == matched)&&const DeepCollectionEquality().equals(other.findings, _findings));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,matched,const DeepCollectionEquality().hash(_findings));
}

@override
String toString() {
    return 'AnalysisResult(matched: $matched, findings: $findings)';
}


}

/// @nodoc
abstract mixin class _$AnalysisResultCopyWith<$Res> implements $AnalysisResultCopyWith<$Res> {
  factory _$AnalysisResultCopyWith(_AnalysisResult value, $Res Function(_AnalysisResult) _then) = __$AnalysisResultCopyWithImpl;
@override @useResult
$Res call({
 bool matched, List<Finding> findings
});




}
/// @nodoc
class __$AnalysisResultCopyWithImpl<$Res>
    implements _$AnalysisResultCopyWith<$Res> {
  __$AnalysisResultCopyWithImpl(this._self, this._then);

  final _AnalysisResult _self;
  final $Res Function(_AnalysisResult) _then;

/// Create a copy of AnalysisResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? matched = null,Object? findings = null,}) {
  return _then(_AnalysisResult(
matched: null == matched ? _self.matched : matched // ignore: cast_nullable_to_non_nullable
as bool,findings: null == findings ? _self._findings : findings // ignore: cast_nullable_to_non_nullable
as List<Finding>,
  ));
}


}


/// @nodoc
mixin _$DiagnosticEntry {

 DateTime get time; String get event; String? get jobId; int? get status; int? get attempt; String? get kind;
/// Create a copy of DiagnosticEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DiagnosticEntryCopyWith<DiagnosticEntry> get copyWith => _$DiagnosticEntryCopyWithImpl<DiagnosticEntry>(this as DiagnosticEntry, _$identity);

  /// Serializes this DiagnosticEntry to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as DiagnosticEntry;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DiagnosticEntry&&(identical(other.time, _this.time) || other.time == _this.time)&&(identical(other.event, _this.event) || other.event == _this.event)&&(identical(other.jobId, _this.jobId) || other.jobId == _this.jobId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.attempt, _this.attempt) || other.attempt == _this.attempt)&&(identical(other.kind, _this.kind) || other.kind == _this.kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as DiagnosticEntry;
  return Object.hash(runtimeType,_this.time,_this.event,_this.jobId,_this.status,_this.attempt,_this.kind);
}

@override
String toString() {
  final _this = this as DiagnosticEntry;
  return 'DiagnosticEntry(time: ${_this.time}, event: ${_this.event}, jobId: ${_this.jobId}, status: ${_this.status}, attempt: ${_this.attempt}, kind: ${_this.kind})';
}


}

/// @nodoc
abstract mixin class $DiagnosticEntryCopyWith<$Res>  {
  factory $DiagnosticEntryCopyWith(DiagnosticEntry value, $Res Function(DiagnosticEntry) _then) = _$DiagnosticEntryCopyWithImpl;
@useResult
$Res call({
 DateTime time, String event, String? jobId, int? status, int? attempt, String? kind
});




}
/// @nodoc
class _$DiagnosticEntryCopyWithImpl<$Res>
    implements $DiagnosticEntryCopyWith<$Res> {
  _$DiagnosticEntryCopyWithImpl(this._self, this._then);

  final DiagnosticEntry _self;
  final $Res Function(DiagnosticEntry) _then;

/// Create a copy of DiagnosticEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? time = null,Object? event = null,Object? jobId = freezed,Object? status = freezed,Object? attempt = freezed,Object? kind = freezed,}) {
  return _then(DiagnosticEntry(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as String,jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int?,attempt: freezed == attempt ? _self.attempt : attempt // ignore: cast_nullable_to_non_nullable
as int?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [DiagnosticEntry].
extension DiagnosticEntryPatterns on DiagnosticEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DiagnosticEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DiagnosticEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DiagnosticEntry value)  $default,){
final _that = this;
switch (_that) {
case _DiagnosticEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DiagnosticEntry value)?  $default,){
final _that = this;
switch (_that) {
case _DiagnosticEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateTime time,  String event,  String? jobId,  int? status,  int? attempt,  String? kind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DiagnosticEntry() when $default != null:
return $default(_that.time,_that.event,_that.jobId,_that.status,_that.attempt,_that.kind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateTime time,  String event,  String? jobId,  int? status,  int? attempt,  String? kind)  $default,) {final _that = this;
switch (_that) {
case _DiagnosticEntry():
return $default(_that.time,_that.event,_that.jobId,_that.status,_that.attempt,_that.kind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateTime time,  String event,  String? jobId,  int? status,  int? attempt,  String? kind)?  $default,) {final _that = this;
switch (_that) {
case _DiagnosticEntry() when $default != null:
return $default(_that.time,_that.event,_that.jobId,_that.status,_that.attempt,_that.kind);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _DiagnosticEntry implements DiagnosticEntry {
  const _DiagnosticEntry({required this.time, required this.event, this.jobId, this.status, this.attempt, this.kind});
  factory _DiagnosticEntry.fromJson(Map<String, dynamic> json) => _$DiagnosticEntryFromJson(json);

@override final  DateTime time;
@override final  String event;
@override final  String? jobId;
@override final  int? status;
@override final  int? attempt;
@override final  String? kind;

/// Create a copy of DiagnosticEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DiagnosticEntryCopyWith<_DiagnosticEntry> get copyWith => __$DiagnosticEntryCopyWithImpl<_DiagnosticEntry>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$DiagnosticEntryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _DiagnosticEntry&&(identical(other.time, time) || other.time == time)&&(identical(other.event, event) || other.event == event)&&(identical(other.jobId, jobId) || other.jobId == jobId)&&(identical(other.status, status) || other.status == status)&&(identical(other.attempt, attempt) || other.attempt == attempt)&&(identical(other.kind, kind) || other.kind == kind));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,time,event,jobId,status,attempt,kind);
}

@override
String toString() {
    return 'DiagnosticEntry(time: $time, event: $event, jobId: $jobId, status: $status, attempt: $attempt, kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$DiagnosticEntryCopyWith<$Res> implements $DiagnosticEntryCopyWith<$Res> {
  factory _$DiagnosticEntryCopyWith(_DiagnosticEntry value, $Res Function(_DiagnosticEntry) _then) = __$DiagnosticEntryCopyWithImpl;
@override @useResult
$Res call({
 DateTime time, String event, String? jobId, int? status, int? attempt, String? kind
});




}
/// @nodoc
class __$DiagnosticEntryCopyWithImpl<$Res>
    implements _$DiagnosticEntryCopyWith<$Res> {
  __$DiagnosticEntryCopyWithImpl(this._self, this._then);

  final _DiagnosticEntry _self;
  final $Res Function(_DiagnosticEntry) _then;

/// Create a copy of DiagnosticEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? time = null,Object? event = null,Object? jobId = freezed,Object? status = freezed,Object? attempt = freezed,Object? kind = freezed,}) {
  return _then(_DiagnosticEntry(
time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as DateTime,event: null == event ? _self.event : event // ignore: cast_nullable_to_non_nullable
as String,jobId: freezed == jobId ? _self.jobId : jobId // ignore: cast_nullable_to_non_nullable
as String?,status: freezed == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as int?,attempt: freezed == attempt ? _self.attempt : attempt // ignore: cast_nullable_to_non_nullable
as int?,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

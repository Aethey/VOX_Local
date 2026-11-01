// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'session_service.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SessionState {

 String? get id; RecordingSummary? get record; SessionPhase get phase; List<TranscriptSegment> get segments; String get partial; String? get error; bool get dictating; String get draft; DateTime? get startedAt; bool get managing;
/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SessionStateCopyWith<SessionState> get copyWith => _$SessionStateCopyWithImpl<SessionState>(this as SessionState, _$identity);



@override
bool operator ==(Object other) {
  final _this = this as SessionState;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SessionState&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.record, _this.record) || other.record == _this.record)&&(identical(other.phase, _this.phase) || other.phase == _this.phase)&&const DeepCollectionEquality().equals(other.segments, _this.segments)&&(identical(other.partial, _this.partial) || other.partial == _this.partial)&&(identical(other.error, _this.error) || other.error == _this.error)&&(identical(other.dictating, _this.dictating) || other.dictating == _this.dictating)&&(identical(other.draft, _this.draft) || other.draft == _this.draft)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.managing, _this.managing) || other.managing == _this.managing));
}


@override
int get hashCode {
  final _this = this as SessionState;
  return Object.hash(runtimeType,_this.id,_this.record,_this.phase,const DeepCollectionEquality().hash(_this.segments),_this.partial,_this.error,_this.dictating,_this.draft,_this.startedAt,_this.managing);
}

@override
String toString() {
  final _this = this as SessionState;
  return 'SessionState(id: ${_this.id}, record: ${_this.record}, phase: ${_this.phase}, segments: ${_this.segments}, partial: ${_this.partial}, error: ${_this.error}, dictating: ${_this.dictating}, draft: ${_this.draft}, startedAt: ${_this.startedAt}, managing: ${_this.managing})';
}


}

/// @nodoc
abstract mixin class $SessionStateCopyWith<$Res>  {
  factory $SessionStateCopyWith(SessionState value, $Res Function(SessionState) _then) = _$SessionStateCopyWithImpl;
@useResult
$Res call({
 String? id, RecordingSummary? record, SessionPhase phase, List<TranscriptSegment> segments, String partial, String? error, bool dictating, String draft, DateTime? startedAt, bool managing
});


$RecordingSummaryCopyWith<$Res>? get record;

}
/// @nodoc
class _$SessionStateCopyWithImpl<$Res>
    implements $SessionStateCopyWith<$Res> {
  _$SessionStateCopyWithImpl(this._self, this._then);

  final SessionState _self;
  final $Res Function(SessionState) _then;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? record = freezed,Object? phase = null,Object? segments = null,Object? partial = null,Object? error = freezed,Object? dictating = null,Object? draft = null,Object? startedAt = freezed,Object? managing = null,}) {
  return _then(SessionState(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,record: freezed == record ? _self.record : record // ignore: cast_nullable_to_non_nullable
as RecordingSummary?,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as SessionPhase,segments: null == segments ? _self.segments : segments // ignore: cast_nullable_to_non_nullable
as List<TranscriptSegment>,partial: null == partial ? _self.partial : partial // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,dictating: null == dictating ? _self.dictating : dictating // ignore: cast_nullable_to_non_nullable
as bool,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,managing: null == managing ? _self.managing : managing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}
/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecordingSummaryCopyWith<$Res>? get record {
    if (_self.record == null) {
    return null;
  }

  return $RecordingSummaryCopyWith<$Res>(_self.record!, (value) {
    return _then(_self.copyWith(record: value));
  });
}
}


/// Adds pattern-matching-related methods to [SessionState].
extension SessionStatePatterns on SessionState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SessionState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SessionState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SessionState value)  $default,){
final _that = this;
switch (_that) {
case _SessionState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SessionState value)?  $default,){
final _that = this;
switch (_that) {
case _SessionState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? id,  RecordingSummary? record,  SessionPhase phase,  List<TranscriptSegment> segments,  String partial,  String? error,  bool dictating,  String draft,  DateTime? startedAt,  bool managing)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SessionState() when $default != null:
return $default(_that.id,_that.record,_that.phase,_that.segments,_that.partial,_that.error,_that.dictating,_that.draft,_that.startedAt,_that.managing);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? id,  RecordingSummary? record,  SessionPhase phase,  List<TranscriptSegment> segments,  String partial,  String? error,  bool dictating,  String draft,  DateTime? startedAt,  bool managing)  $default,) {final _that = this;
switch (_that) {
case _SessionState():
return $default(_that.id,_that.record,_that.phase,_that.segments,_that.partial,_that.error,_that.dictating,_that.draft,_that.startedAt,_that.managing);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? id,  RecordingSummary? record,  SessionPhase phase,  List<TranscriptSegment> segments,  String partial,  String? error,  bool dictating,  String draft,  DateTime? startedAt,  bool managing)?  $default,) {final _that = this;
switch (_that) {
case _SessionState() when $default != null:
return $default(_that.id,_that.record,_that.phase,_that.segments,_that.partial,_that.error,_that.dictating,_that.draft,_that.startedAt,_that.managing);case _:
  return null;

}
}

}

/// @nodoc


class _SessionState extends SessionState {
  const _SessionState({this.id, this.record, this.phase = SessionPhase.idle,  List<TranscriptSegment> segments = const [], this.partial = '', this.error, this.dictating = false, this.draft = '', this.startedAt, this.managing = false}): _segments = segments,super._();
  

@override final  String? id;
@override final  RecordingSummary? record;
@override@JsonKey() final  SessionPhase phase;
 final  List<TranscriptSegment> _segments;
@override@JsonKey() List<TranscriptSegment> get segments {
  if (_segments is EqualUnmodifiableListView) return _segments;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_segments);
}

@override@JsonKey() final  String partial;
@override final  String? error;
@override@JsonKey() final  bool dictating;
@override@JsonKey() final  String draft;
@override final  DateTime? startedAt;
@override@JsonKey() final  bool managing;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SessionStateCopyWith<_SessionState> get copyWith => __$SessionStateCopyWithImpl<_SessionState>(this, _$identity);



@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _SessionState&&(identical(other.id, id) || other.id == id)&&(identical(other.record, record) || other.record == record)&&(identical(other.phase, phase) || other.phase == phase)&&const DeepCollectionEquality().equals(other.segments, _segments)&&(identical(other.partial, partial) || other.partial == partial)&&(identical(other.error, error) || other.error == error)&&(identical(other.dictating, dictating) || other.dictating == dictating)&&(identical(other.draft, draft) || other.draft == draft)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.managing, managing) || other.managing == managing));
}


@override
int get hashCode {
    return Object.hash(runtimeType,id,record,phase,const DeepCollectionEquality().hash(_segments),partial,error,dictating,draft,startedAt,managing);
}

@override
String toString() {
    return 'SessionState(id: $id, record: $record, phase: $phase, segments: $segments, partial: $partial, error: $error, dictating: $dictating, draft: $draft, startedAt: $startedAt, managing: $managing)';
}


}

/// @nodoc
abstract mixin class _$SessionStateCopyWith<$Res> implements $SessionStateCopyWith<$Res> {
  factory _$SessionStateCopyWith(_SessionState value, $Res Function(_SessionState) _then) = __$SessionStateCopyWithImpl;
@override @useResult
$Res call({
 String? id, RecordingSummary? record, SessionPhase phase, List<TranscriptSegment> segments, String partial, String? error, bool dictating, String draft, DateTime? startedAt, bool managing
});


@override $RecordingSummaryCopyWith<$Res>? get record;

}
/// @nodoc
class __$SessionStateCopyWithImpl<$Res>
    implements _$SessionStateCopyWith<$Res> {
  __$SessionStateCopyWithImpl(this._self, this._then);

  final _SessionState _self;
  final $Res Function(_SessionState) _then;

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? record = freezed,Object? phase = null,Object? segments = null,Object? partial = null,Object? error = freezed,Object? dictating = null,Object? draft = null,Object? startedAt = freezed,Object? managing = null,}) {
  return _then(_SessionState(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,record: freezed == record ? _self.record : record // ignore: cast_nullable_to_non_nullable
as RecordingSummary?,phase: null == phase ? _self.phase : phase // ignore: cast_nullable_to_non_nullable
as SessionPhase,segments: null == segments ? _self._segments : segments // ignore: cast_nullable_to_non_nullable
as List<TranscriptSegment>,partial: null == partial ? _self.partial : partial // ignore: cast_nullable_to_non_nullable
as String,error: freezed == error ? _self.error : error // ignore: cast_nullable_to_non_nullable
as String?,dictating: null == dictating ? _self.dictating : dictating // ignore: cast_nullable_to_non_nullable
as bool,draft: null == draft ? _self.draft : draft // ignore: cast_nullable_to_non_nullable
as String,startedAt: freezed == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,managing: null == managing ? _self.managing : managing // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

/// Create a copy of SessionState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$RecordingSummaryCopyWith<$Res>? get record {
    if (_self.record == null) {
    return null;
  }

  return $RecordingSummaryCopyWith<$Res>(_self.record!, (value) {
    return _then(_self.copyWith(record: value));
  });
}
}

// dart format on

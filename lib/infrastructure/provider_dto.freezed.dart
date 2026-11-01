// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'provider_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ModelIdDto {

 String get id;
/// Create a copy of ModelIdDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModelIdDtoCopyWith<ModelIdDto> get copyWith => _$ModelIdDtoCopyWithImpl<ModelIdDto>(this as ModelIdDto, _$identity);

  /// Serializes this ModelIdDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ModelIdDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelIdDto&&(identical(other.id, _this.id) || other.id == _this.id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ModelIdDto;
  return Object.hash(runtimeType,_this.id);
}

@override
String toString() {
  final _this = this as ModelIdDto;
  return 'ModelIdDto(id: ${_this.id})';
}


}

/// @nodoc
abstract mixin class $ModelIdDtoCopyWith<$Res>  {
  factory $ModelIdDtoCopyWith(ModelIdDto value, $Res Function(ModelIdDto) _then) = _$ModelIdDtoCopyWithImpl;
@useResult
$Res call({
 String id
});




}
/// @nodoc
class _$ModelIdDtoCopyWithImpl<$Res>
    implements $ModelIdDtoCopyWith<$Res> {
  _$ModelIdDtoCopyWithImpl(this._self, this._then);

  final ModelIdDto _self;
  final $Res Function(ModelIdDto) _then;

/// Create a copy of ModelIdDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,}) {
  return _then(ModelIdDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ModelIdDto].
extension ModelIdDtoPatterns on ModelIdDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModelIdDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModelIdDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModelIdDto value)  $default,){
final _that = this;
switch (_that) {
case _ModelIdDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModelIdDto value)?  $default,){
final _that = this;
switch (_that) {
case _ModelIdDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModelIdDto() when $default != null:
return $default(_that.id);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id)  $default,) {final _that = this;
switch (_that) {
case _ModelIdDto():
return $default(_that.id);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id)?  $default,) {final _that = this;
switch (_that) {
case _ModelIdDto() when $default != null:
return $default(_that.id);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ModelIdDto implements ModelIdDto {
  const _ModelIdDto({required this.id});
  factory _ModelIdDto.fromJson(Map<String, dynamic> json) => _$ModelIdDtoFromJson(json);

@override final  String id;

/// Create a copy of ModelIdDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModelIdDtoCopyWith<_ModelIdDto> get copyWith => __$ModelIdDtoCopyWithImpl<_ModelIdDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModelIdDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModelIdDto&&(identical(other.id, id) || other.id == id));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id);
}

@override
String toString() {
    return 'ModelIdDto(id: $id)';
}


}

/// @nodoc
abstract mixin class _$ModelIdDtoCopyWith<$Res> implements $ModelIdDtoCopyWith<$Res> {
  factory _$ModelIdDtoCopyWith(_ModelIdDto value, $Res Function(_ModelIdDto) _then) = __$ModelIdDtoCopyWithImpl;
@override @useResult
$Res call({
 String id
});




}
/// @nodoc
class __$ModelIdDtoCopyWithImpl<$Res>
    implements _$ModelIdDtoCopyWith<$Res> {
  __$ModelIdDtoCopyWithImpl(this._self, this._then);

  final _ModelIdDto _self;
  final $Res Function(_ModelIdDto) _then;

/// Create a copy of ModelIdDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,}) {
  return _then(_ModelIdDto(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ModelListDto {

 List<ModelIdDto> get data;
/// Create a copy of ModelListDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ModelListDtoCopyWith<ModelListDto> get copyWith => _$ModelListDtoCopyWithImpl<ModelListDto>(this as ModelListDto, _$identity);

  /// Serializes this ModelListDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ModelListDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ModelListDto&&const DeepCollectionEquality().equals(other.data, _this.data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ModelListDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.data));
}

@override
String toString() {
  final _this = this as ModelListDto;
  return 'ModelListDto(data: ${_this.data})';
}


}

/// @nodoc
abstract mixin class $ModelListDtoCopyWith<$Res>  {
  factory $ModelListDtoCopyWith(ModelListDto value, $Res Function(ModelListDto) _then) = _$ModelListDtoCopyWithImpl;
@useResult
$Res call({
 List<ModelIdDto> data
});




}
/// @nodoc
class _$ModelListDtoCopyWithImpl<$Res>
    implements $ModelListDtoCopyWith<$Res> {
  _$ModelListDtoCopyWithImpl(this._self, this._then);

  final ModelListDto _self;
  final $Res Function(ModelListDto) _then;

/// Create a copy of ModelListDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? data = null,}) {
  return _then(ModelListDto(
data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as List<ModelIdDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [ModelListDto].
extension ModelListDtoPatterns on ModelListDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ModelListDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ModelListDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ModelListDto value)  $default,){
final _that = this;
switch (_that) {
case _ModelListDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ModelListDto value)?  $default,){
final _that = this;
switch (_that) {
case _ModelListDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ModelIdDto> data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ModelListDto() when $default != null:
return $default(_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ModelIdDto> data)  $default,) {final _that = this;
switch (_that) {
case _ModelListDto():
return $default(_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ModelIdDto> data)?  $default,) {final _that = this;
switch (_that) {
case _ModelListDto() when $default != null:
return $default(_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ModelListDto implements ModelListDto {
  const _ModelListDto({required  List<ModelIdDto> data}): _data = data;
  factory _ModelListDto.fromJson(Map<String, dynamic> json) => _$ModelListDtoFromJson(json);

 final  List<ModelIdDto> _data;
@override List<ModelIdDto> get data {
  if (_data is EqualUnmodifiableListView) return _data;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_data);
}


/// Create a copy of ModelListDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ModelListDtoCopyWith<_ModelListDto> get copyWith => __$ModelListDtoCopyWithImpl<_ModelListDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ModelListDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ModelListDto&&const DeepCollectionEquality().equals(other.data, _data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_data));
}

@override
String toString() {
    return 'ModelListDto(data: $data)';
}


}

/// @nodoc
abstract mixin class _$ModelListDtoCopyWith<$Res> implements $ModelListDtoCopyWith<$Res> {
  factory _$ModelListDtoCopyWith(_ModelListDto value, $Res Function(_ModelListDto) _then) = __$ModelListDtoCopyWithImpl;
@override @useResult
$Res call({
 List<ModelIdDto> data
});




}
/// @nodoc
class __$ModelListDtoCopyWithImpl<$Res>
    implements _$ModelListDtoCopyWith<$Res> {
  __$ModelListDtoCopyWithImpl(this._self, this._then);

  final _ModelListDto _self;
  final $Res Function(_ModelListDto) _then;

/// Create a copy of ModelListDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? data = null,}) {
  return _then(_ModelListDto(
data: null == data ? _self._data : data // ignore: cast_nullable_to_non_nullable
as List<ModelIdDto>,
  ));
}


}


/// @nodoc
mixin _$MessageDto {

 String? get role; String? get content;
/// Create a copy of MessageDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageDtoCopyWith<MessageDto> get copyWith => _$MessageDtoCopyWithImpl<MessageDto>(this as MessageDto, _$identity);

  /// Serializes this MessageDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MessageDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MessageDto&&(identical(other.role, _this.role) || other.role == _this.role)&&(identical(other.content, _this.content) || other.content == _this.content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MessageDto;
  return Object.hash(runtimeType,_this.role,_this.content);
}

@override
String toString() {
  final _this = this as MessageDto;
  return 'MessageDto(role: ${_this.role}, content: ${_this.content})';
}


}

/// @nodoc
abstract mixin class $MessageDtoCopyWith<$Res>  {
  factory $MessageDtoCopyWith(MessageDto value, $Res Function(MessageDto) _then) = _$MessageDtoCopyWithImpl;
@useResult
$Res call({
 String? role, String? content
});




}
/// @nodoc
class _$MessageDtoCopyWithImpl<$Res>
    implements $MessageDtoCopyWith<$Res> {
  _$MessageDtoCopyWithImpl(this._self, this._then);

  final MessageDto _self;
  final $Res Function(MessageDto) _then;

/// Create a copy of MessageDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? role = freezed,Object? content = freezed,}) {
  return _then(MessageDto(
role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [MessageDto].
extension MessageDtoPatterns on MessageDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MessageDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MessageDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MessageDto value)  $default,){
final _that = this;
switch (_that) {
case _MessageDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MessageDto value)?  $default,){
final _that = this;
switch (_that) {
case _MessageDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? role,  String? content)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MessageDto() when $default != null:
return $default(_that.role,_that.content);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? role,  String? content)  $default,) {final _that = this;
switch (_that) {
case _MessageDto():
return $default(_that.role,_that.content);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? role,  String? content)?  $default,) {final _that = this;
switch (_that) {
case _MessageDto() when $default != null:
return $default(_that.role,_that.content);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MessageDto implements MessageDto {
  const _MessageDto({this.role, this.content});
  factory _MessageDto.fromJson(Map<String, dynamic> json) => _$MessageDtoFromJson(json);

@override final  String? role;
@override final  String? content;

/// Create a copy of MessageDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageDtoCopyWith<_MessageDto> get copyWith => __$MessageDtoCopyWithImpl<_MessageDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MessageDto&&(identical(other.role, role) || other.role == role)&&(identical(other.content, content) || other.content == content));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,role,content);
}

@override
String toString() {
    return 'MessageDto(role: $role, content: $content)';
}


}

/// @nodoc
abstract mixin class _$MessageDtoCopyWith<$Res> implements $MessageDtoCopyWith<$Res> {
  factory _$MessageDtoCopyWith(_MessageDto value, $Res Function(_MessageDto) _then) = __$MessageDtoCopyWithImpl;
@override @useResult
$Res call({
 String? role, String? content
});




}
/// @nodoc
class __$MessageDtoCopyWithImpl<$Res>
    implements _$MessageDtoCopyWith<$Res> {
  __$MessageDtoCopyWithImpl(this._self, this._then);

  final _MessageDto _self;
  final $Res Function(_MessageDto) _then;

/// Create a copy of MessageDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? role = freezed,Object? content = freezed,}) {
  return _then(_MessageDto(
role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$ChoiceDto {

@JsonKey(name: 'finish_reason') String? get finishReason; MessageDto get message;
/// Create a copy of ChoiceDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChoiceDtoCopyWith<ChoiceDto> get copyWith => _$ChoiceDtoCopyWithImpl<ChoiceDto>(this as ChoiceDto, _$identity);

  /// Serializes this ChoiceDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ChoiceDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChoiceDto&&(identical(other.finishReason, _this.finishReason) || other.finishReason == _this.finishReason)&&(identical(other.message, _this.message) || other.message == _this.message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ChoiceDto;
  return Object.hash(runtimeType,_this.finishReason,_this.message);
}

@override
String toString() {
  final _this = this as ChoiceDto;
  return 'ChoiceDto(finishReason: ${_this.finishReason}, message: ${_this.message})';
}


}

/// @nodoc
abstract mixin class $ChoiceDtoCopyWith<$Res>  {
  factory $ChoiceDtoCopyWith(ChoiceDto value, $Res Function(ChoiceDto) _then) = _$ChoiceDtoCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: 'finish_reason') String? finishReason, MessageDto message
});


$MessageDtoCopyWith<$Res> get message;

}
/// @nodoc
class _$ChoiceDtoCopyWithImpl<$Res>
    implements $ChoiceDtoCopyWith<$Res> {
  _$ChoiceDtoCopyWithImpl(this._self, this._then);

  final ChoiceDto _self;
  final $Res Function(ChoiceDto) _then;

/// Create a copy of ChoiceDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? finishReason = freezed,Object? message = null,}) {
  return _then(ChoiceDto(
finishReason: freezed == finishReason ? _self.finishReason : finishReason // ignore: cast_nullable_to_non_nullable
as String?,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as MessageDto,
  ));
}
/// Create a copy of ChoiceDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageDtoCopyWith<$Res> get message {
  
  return $MessageDtoCopyWith<$Res>(_self.message, (value) {
    return _then(_self.copyWith(message: value));
  });
}
}


/// Adds pattern-matching-related methods to [ChoiceDto].
extension ChoiceDtoPatterns on ChoiceDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ChoiceDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ChoiceDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ChoiceDto value)  $default,){
final _that = this;
switch (_that) {
case _ChoiceDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ChoiceDto value)?  $default,){
final _that = this;
switch (_that) {
case _ChoiceDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: 'finish_reason')  String? finishReason,  MessageDto message)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ChoiceDto() when $default != null:
return $default(_that.finishReason,_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: 'finish_reason')  String? finishReason,  MessageDto message)  $default,) {final _that = this;
switch (_that) {
case _ChoiceDto():
return $default(_that.finishReason,_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: 'finish_reason')  String? finishReason,  MessageDto message)?  $default,) {final _that = this;
switch (_that) {
case _ChoiceDto() when $default != null:
return $default(_that.finishReason,_that.message);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ChoiceDto implements ChoiceDto {
  const _ChoiceDto({@JsonKey(name: 'finish_reason') this.finishReason, required this.message});
  factory _ChoiceDto.fromJson(Map<String, dynamic> json) => _$ChoiceDtoFromJson(json);

@override@JsonKey(name: 'finish_reason') final  String? finishReason;
@override final  MessageDto message;

/// Create a copy of ChoiceDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChoiceDtoCopyWith<_ChoiceDto> get copyWith => __$ChoiceDtoCopyWithImpl<_ChoiceDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ChoiceDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChoiceDto&&(identical(other.finishReason, finishReason) || other.finishReason == finishReason)&&(identical(other.message, message) || other.message == message));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,finishReason,message);
}

@override
String toString() {
    return 'ChoiceDto(finishReason: $finishReason, message: $message)';
}


}

/// @nodoc
abstract mixin class _$ChoiceDtoCopyWith<$Res> implements $ChoiceDtoCopyWith<$Res> {
  factory _$ChoiceDtoCopyWith(_ChoiceDto value, $Res Function(_ChoiceDto) _then) = __$ChoiceDtoCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: 'finish_reason') String? finishReason, MessageDto message
});


@override $MessageDtoCopyWith<$Res> get message;

}
/// @nodoc
class __$ChoiceDtoCopyWithImpl<$Res>
    implements _$ChoiceDtoCopyWith<$Res> {
  __$ChoiceDtoCopyWithImpl(this._self, this._then);

  final _ChoiceDto _self;
  final $Res Function(_ChoiceDto) _then;

/// Create a copy of ChoiceDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? finishReason = freezed,Object? message = null,}) {
  return _then(_ChoiceDto(
finishReason: freezed == finishReason ? _self.finishReason : finishReason // ignore: cast_nullable_to_non_nullable
as String?,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as MessageDto,
  ));
}

/// Create a copy of ChoiceDto
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$MessageDtoCopyWith<$Res> get message {
  
  return $MessageDtoCopyWith<$Res>(_self.message, (value) {
    return _then(_self.copyWith(message: value));
  });
}
}


/// @nodoc
mixin _$CompletionDto {

 List<ChoiceDto> get choices;
/// Create a copy of CompletionDto
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompletionDtoCopyWith<CompletionDto> get copyWith => _$CompletionDtoCopyWithImpl<CompletionDto>(this as CompletionDto, _$identity);

  /// Serializes this CompletionDto to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CompletionDto;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompletionDto&&const DeepCollectionEquality().equals(other.choices, _this.choices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CompletionDto;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.choices));
}

@override
String toString() {
  final _this = this as CompletionDto;
  return 'CompletionDto(choices: ${_this.choices})';
}


}

/// @nodoc
abstract mixin class $CompletionDtoCopyWith<$Res>  {
  factory $CompletionDtoCopyWith(CompletionDto value, $Res Function(CompletionDto) _then) = _$CompletionDtoCopyWithImpl;
@useResult
$Res call({
 List<ChoiceDto> choices
});




}
/// @nodoc
class _$CompletionDtoCopyWithImpl<$Res>
    implements $CompletionDtoCopyWith<$Res> {
  _$CompletionDtoCopyWithImpl(this._self, this._then);

  final CompletionDto _self;
  final $Res Function(CompletionDto) _then;

/// Create a copy of CompletionDto
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? choices = null,}) {
  return _then(CompletionDto(
choices: null == choices ? _self.choices : choices // ignore: cast_nullable_to_non_nullable
as List<ChoiceDto>,
  ));
}

}


/// Adds pattern-matching-related methods to [CompletionDto].
extension CompletionDtoPatterns on CompletionDto {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompletionDto value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompletionDto() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompletionDto value)  $default,){
final _that = this;
switch (_that) {
case _CompletionDto():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompletionDto value)?  $default,){
final _that = this;
switch (_that) {
case _CompletionDto() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<ChoiceDto> choices)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompletionDto() when $default != null:
return $default(_that.choices);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<ChoiceDto> choices)  $default,) {final _that = this;
switch (_that) {
case _CompletionDto():
return $default(_that.choices);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<ChoiceDto> choices)?  $default,) {final _that = this;
switch (_that) {
case _CompletionDto() when $default != null:
return $default(_that.choices);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompletionDto implements CompletionDto {
  const _CompletionDto({required  List<ChoiceDto> choices}): _choices = choices;
  factory _CompletionDto.fromJson(Map<String, dynamic> json) => _$CompletionDtoFromJson(json);

 final  List<ChoiceDto> _choices;
@override List<ChoiceDto> get choices {
  if (_choices is EqualUnmodifiableListView) return _choices;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_choices);
}


/// Create a copy of CompletionDto
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompletionDtoCopyWith<_CompletionDto> get copyWith => __$CompletionDtoCopyWithImpl<_CompletionDto>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompletionDtoToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompletionDto&&const DeepCollectionEquality().equals(other.choices, _choices));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_choices));
}

@override
String toString() {
    return 'CompletionDto(choices: $choices)';
}


}

/// @nodoc
abstract mixin class _$CompletionDtoCopyWith<$Res> implements $CompletionDtoCopyWith<$Res> {
  factory _$CompletionDtoCopyWith(_CompletionDto value, $Res Function(_CompletionDto) _then) = __$CompletionDtoCopyWithImpl;
@override @useResult
$Res call({
 List<ChoiceDto> choices
});




}
/// @nodoc
class __$CompletionDtoCopyWithImpl<$Res>
    implements _$CompletionDtoCopyWith<$Res> {
  __$CompletionDtoCopyWithImpl(this._self, this._then);

  final _CompletionDto _self;
  final $Res Function(_CompletionDto) _then;

/// Create a copy of CompletionDto
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? choices = null,}) {
  return _then(_CompletionDto(
choices: null == choices ? _self._choices : choices // ignore: cast_nullable_to_non_nullable
as List<ChoiceDto>,
  ));
}


}


/// @nodoc
mixin _$CompletionRequest {

 String get model; bool get stream;@JsonKey(name: 'max_tokens') int get maxTokens; List<MessageDto> get messages;@JsonKey(includeIfNull: false) Map<String, String>? get thinking;
/// Create a copy of CompletionRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CompletionRequestCopyWith<CompletionRequest> get copyWith => _$CompletionRequestCopyWithImpl<CompletionRequest>(this as CompletionRequest, _$identity);

  /// Serializes this CompletionRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as CompletionRequest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CompletionRequest&&(identical(other.model, _this.model) || other.model == _this.model)&&(identical(other.stream, _this.stream) || other.stream == _this.stream)&&(identical(other.maxTokens, _this.maxTokens) || other.maxTokens == _this.maxTokens)&&const DeepCollectionEquality().equals(other.messages, _this.messages)&&const DeepCollectionEquality().equals(other.thinking, _this.thinking));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as CompletionRequest;
  return Object.hash(runtimeType,_this.model,_this.stream,_this.maxTokens,const DeepCollectionEquality().hash(_this.messages),const DeepCollectionEquality().hash(_this.thinking));
}

@override
String toString() {
  final _this = this as CompletionRequest;
  return 'CompletionRequest(model: ${_this.model}, stream: ${_this.stream}, maxTokens: ${_this.maxTokens}, messages: ${_this.messages}, thinking: ${_this.thinking})';
}


}

/// @nodoc
abstract mixin class $CompletionRequestCopyWith<$Res>  {
  factory $CompletionRequestCopyWith(CompletionRequest value, $Res Function(CompletionRequest) _then) = _$CompletionRequestCopyWithImpl;
@useResult
$Res call({
 String model, bool stream,@JsonKey(name: 'max_tokens') int maxTokens, List<MessageDto> messages,@JsonKey(includeIfNull: false) Map<String, String>? thinking
});




}
/// @nodoc
class _$CompletionRequestCopyWithImpl<$Res>
    implements $CompletionRequestCopyWith<$Res> {
  _$CompletionRequestCopyWithImpl(this._self, this._then);

  final CompletionRequest _self;
  final $Res Function(CompletionRequest) _then;

/// Create a copy of CompletionRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? model = null,Object? stream = null,Object? maxTokens = null,Object? messages = null,Object? thinking = freezed,}) {
  return _then(CompletionRequest(
model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,stream: null == stream ? _self.stream : stream // ignore: cast_nullable_to_non_nullable
as bool,maxTokens: null == maxTokens ? _self.maxTokens : maxTokens // ignore: cast_nullable_to_non_nullable
as int,messages: null == messages ? _self.messages : messages // ignore: cast_nullable_to_non_nullable
as List<MessageDto>,thinking: freezed == thinking ? _self.thinking : thinking // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}

}


/// Adds pattern-matching-related methods to [CompletionRequest].
extension CompletionRequestPatterns on CompletionRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CompletionRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CompletionRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CompletionRequest value)  $default,){
final _that = this;
switch (_that) {
case _CompletionRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CompletionRequest value)?  $default,){
final _that = this;
switch (_that) {
case _CompletionRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String model,  bool stream, @JsonKey(name: 'max_tokens')  int maxTokens,  List<MessageDto> messages, @JsonKey(includeIfNull: false)  Map<String, String>? thinking)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CompletionRequest() when $default != null:
return $default(_that.model,_that.stream,_that.maxTokens,_that.messages,_that.thinking);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String model,  bool stream, @JsonKey(name: 'max_tokens')  int maxTokens,  List<MessageDto> messages, @JsonKey(includeIfNull: false)  Map<String, String>? thinking)  $default,) {final _that = this;
switch (_that) {
case _CompletionRequest():
return $default(_that.model,_that.stream,_that.maxTokens,_that.messages,_that.thinking);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String model,  bool stream, @JsonKey(name: 'max_tokens')  int maxTokens,  List<MessageDto> messages, @JsonKey(includeIfNull: false)  Map<String, String>? thinking)?  $default,) {final _that = this;
switch (_that) {
case _CompletionRequest() when $default != null:
return $default(_that.model,_that.stream,_that.maxTokens,_that.messages,_that.thinking);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _CompletionRequest implements CompletionRequest {
  const _CompletionRequest({required this.model, this.stream = false, @JsonKey(name: 'max_tokens') required this.maxTokens, required  List<MessageDto> messages, @JsonKey(includeIfNull: false)  Map<String, String>? thinking}): _messages = messages,_thinking = thinking;
  factory _CompletionRequest.fromJson(Map<String, dynamic> json) => _$CompletionRequestFromJson(json);

@override final  String model;
@override@JsonKey() final  bool stream;
@override@JsonKey(name: 'max_tokens') final  int maxTokens;
 final  List<MessageDto> _messages;
@override List<MessageDto> get messages {
  if (_messages is EqualUnmodifiableListView) return _messages;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_messages);
}

 final  Map<String, String>? _thinking;
@override@JsonKey(includeIfNull: false) Map<String, String>? get thinking {
  final value = _thinking;
  if (value == null) return null;
  if (_thinking is EqualUnmodifiableMapView) return _thinking;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(value);
}


/// Create a copy of CompletionRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CompletionRequestCopyWith<_CompletionRequest> get copyWith => __$CompletionRequestCopyWithImpl<_CompletionRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$CompletionRequestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _CompletionRequest&&(identical(other.model, model) || other.model == model)&&(identical(other.stream, stream) || other.stream == stream)&&(identical(other.maxTokens, maxTokens) || other.maxTokens == maxTokens)&&const DeepCollectionEquality().equals(other.messages, _messages)&&const DeepCollectionEquality().equals(other.thinking, _thinking));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,model,stream,maxTokens,const DeepCollectionEquality().hash(_messages),const DeepCollectionEquality().hash(_thinking));
}

@override
String toString() {
    return 'CompletionRequest(model: $model, stream: $stream, maxTokens: $maxTokens, messages: $messages, thinking: $thinking)';
}


}

/// @nodoc
abstract mixin class _$CompletionRequestCopyWith<$Res> implements $CompletionRequestCopyWith<$Res> {
  factory _$CompletionRequestCopyWith(_CompletionRequest value, $Res Function(_CompletionRequest) _then) = __$CompletionRequestCopyWithImpl;
@override @useResult
$Res call({
 String model, bool stream,@JsonKey(name: 'max_tokens') int maxTokens, List<MessageDto> messages,@JsonKey(includeIfNull: false) Map<String, String>? thinking
});




}
/// @nodoc
class __$CompletionRequestCopyWithImpl<$Res>
    implements _$CompletionRequestCopyWith<$Res> {
  __$CompletionRequestCopyWithImpl(this._self, this._then);

  final _CompletionRequest _self;
  final $Res Function(_CompletionRequest) _then;

/// Create a copy of CompletionRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? model = null,Object? stream = null,Object? maxTokens = null,Object? messages = null,Object? thinking = freezed,}) {
  return _then(_CompletionRequest(
model: null == model ? _self.model : model // ignore: cast_nullable_to_non_nullable
as String,stream: null == stream ? _self.stream : stream // ignore: cast_nullable_to_non_nullable
as bool,maxTokens: null == maxTokens ? _self.maxTokens : maxTokens // ignore: cast_nullable_to_non_nullable
as int,messages: null == messages ? _self._messages : messages // ignore: cast_nullable_to_non_nullable
as List<MessageDto>,thinking: freezed == thinking ? _self._thinking : thinking // ignore: cast_nullable_to_non_nullable
as Map<String, String>?,
  ));
}


}

// dart format on

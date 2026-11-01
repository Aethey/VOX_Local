import 'package:freezed_annotation/freezed_annotation.dart';
part 'provider_dto.freezed.dart';
part 'provider_dto.g.dart';

@freezed
abstract class ModelIdDto with _$ModelIdDto {
  const factory ModelIdDto({required String id}) = _ModelIdDto;
  factory ModelIdDto.fromJson(Map<String, dynamic> json) =>
      _$ModelIdDtoFromJson(json);
}

@freezed
abstract class ModelListDto with _$ModelListDto {
  const factory ModelListDto({required List<ModelIdDto> data}) = _ModelListDto;
  factory ModelListDto.fromJson(Map<String, dynamic> json) =>
      _$ModelListDtoFromJson(json);
}

@freezed
abstract class MessageDto with _$MessageDto {
  const factory MessageDto({String? role, String? content}) = _MessageDto;
  factory MessageDto.fromJson(Map<String, dynamic> json) =>
      _$MessageDtoFromJson(json);
}

@freezed
abstract class ChoiceDto with _$ChoiceDto {
  const factory ChoiceDto({
    @JsonKey(name: 'finish_reason') String? finishReason,
    required MessageDto message,
  }) = _ChoiceDto;
  factory ChoiceDto.fromJson(Map<String, dynamic> json) =>
      _$ChoiceDtoFromJson(json);
}

@freezed
abstract class CompletionDto with _$CompletionDto {
  const factory CompletionDto({required List<ChoiceDto> choices}) =
      _CompletionDto;
  factory CompletionDto.fromJson(Map<String, dynamic> json) =>
      _$CompletionDtoFromJson(json);
}

@freezed
abstract class CompletionRequest with _$CompletionRequest {
  const factory CompletionRequest({
    required String model,
    @Default(false) bool stream,
    @JsonKey(name: 'max_tokens') required int maxTokens,
    required List<MessageDto> messages,
    @JsonKey(includeIfNull: false) Map<String, String>? thinking,
  }) = _CompletionRequest;
  factory CompletionRequest.fromJson(Map<String, dynamic> json) =>
      _$CompletionRequestFromJson(json);
}

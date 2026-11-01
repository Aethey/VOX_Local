// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provider_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ModelIdDto _$ModelIdDtoFromJson(Map<String, dynamic> json) =>
    _ModelIdDto(id: json['id'] as String);

Map<String, dynamic> _$ModelIdDtoToJson(_ModelIdDto instance) =>
    <String, dynamic>{'id': instance.id};

_ModelListDto _$ModelListDtoFromJson(Map<String, dynamic> json) =>
    _ModelListDto(
      data: (json['data'] as List<dynamic>)
          .map((e) => ModelIdDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ModelListDtoToJson(_ModelListDto instance) =>
    <String, dynamic>{'data': instance.data.map((e) => e.toJson()).toList()};

_MessageDto _$MessageDtoFromJson(Map<String, dynamic> json) => _MessageDto(
  role: json['role'] as String?,
  content: json['content'] as String?,
);

Map<String, dynamic> _$MessageDtoToJson(_MessageDto instance) =>
    <String, dynamic>{'role': instance.role, 'content': instance.content};

_ChoiceDto _$ChoiceDtoFromJson(Map<String, dynamic> json) => _ChoiceDto(
  finishReason: json['finish_reason'] as String?,
  message: MessageDto.fromJson(json['message'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ChoiceDtoToJson(_ChoiceDto instance) =>
    <String, dynamic>{
      'finish_reason': instance.finishReason,
      'message': instance.message.toJson(),
    };

_CompletionDto _$CompletionDtoFromJson(Map<String, dynamic> json) =>
    _CompletionDto(
      choices: (json['choices'] as List<dynamic>)
          .map((e) => ChoiceDto.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$CompletionDtoToJson(_CompletionDto instance) =>
    <String, dynamic>{
      'choices': instance.choices.map((e) => e.toJson()).toList(),
    };

_CompletionRequest _$CompletionRequestFromJson(Map<String, dynamic> json) =>
    _CompletionRequest(
      model: json['model'] as String,
      stream: json['stream'] as bool? ?? false,
      maxTokens: (json['max_tokens'] as num).toInt(),
      messages: (json['messages'] as List<dynamic>)
          .map((e) => MessageDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      thinking: (json['thinking'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
    );

Map<String, dynamic> _$CompletionRequestToJson(_CompletionRequest instance) =>
    <String, dynamic>{
      'model': instance.model,
      'stream': instance.stream,
      'max_tokens': instance.maxTokens,
      'messages': instance.messages.map((e) => e.toJson()).toList(),
      'thinking': ?instance.thinking,
    };

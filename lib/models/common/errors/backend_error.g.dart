// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'backend_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BackendError _$BackendErrorFromJson(Map<String, dynamic> json) {
  return BackendError(
    error: json['error'],
    fields: (json['fields'] as List)
        ?.map((e) => e == null
            ? null
            : FieldValidationError.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$BackendErrorToJson(BackendError instance) =>
    <String, dynamic>{
      'error': instance.error,
      'fields': instance.fields?.map((e) => e?.toJson())?.toList(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'failure.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Failure _$FailureFromJson(Map<String, dynamic> json) {
  return Failure(
    error: json['error'],
    fields: (json['fields'] as List)
        ?.map((e) => e == null
            ? null
            : FieldValidationError.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$FailureToJson(Failure instance) => <String, dynamic>{
      'error': instance.error,
      'fields': instance.fields?.map((e) => e?.toJson())?.toList(),
    };

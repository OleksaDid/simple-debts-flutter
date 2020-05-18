// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'field_validation_error.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FieldValidationError _$FieldValidationErrorFromJson(Map<String, dynamic> json) {
  return FieldValidationError(
    target: json['target'],
    property: json['property'] as String,
    value: json['value'],
    constraints: (json['constraints'] as Map<String, dynamic>)?.map(
      (k, e) => MapEntry(k, e as String),
    ),
    children: (json['children'] as List)
        ?.map((e) => e == null
            ? null
            : FieldValidationError.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$FieldValidationErrorToJson(
        FieldValidationError instance) =>
    <String, dynamic>{
      'target': instance.target,
      'property': instance.property,
      'value': instance.value,
      'constraints': instance.constraints,
      'children': instance.children?.map((e) => e?.toJson())?.toList(),
    };

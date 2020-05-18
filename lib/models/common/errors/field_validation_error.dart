import 'package:json_annotation/json_annotation.dart';

part 'field_validation_error.g.dart';

@JsonSerializable(explicitToJson: true)
class FieldValidationError {
  final Object target;
  final String property;
  final dynamic value;
  final Map<String, String> constraints;
  final List<FieldValidationError> children;

  FieldValidationError({
    this.target,
    this.property,
    this.value,
    this.constraints,
    this.children
  });

  factory FieldValidationError.fromJson(Map<String, dynamic> json) => _$FieldValidationErrorFromJson(json);
  Map<String, dynamic> toJson() => _$FieldValidationErrorToJson(this);
}
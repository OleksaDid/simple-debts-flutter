import 'package:json_annotation/json_annotation.dart';
import 'package:simpledebts/models/common/errors/field_validation_error.dart';

part 'backend_error.g.dart';

@JsonSerializable(explicitToJson: true)
class BackendError {
  final dynamic error;
  final List<FieldValidationError> fields;

  BackendError({
    this.error,
    this.fields
  });

  factory BackendError.fromJson(Map<String, dynamic> json) => _$BackendErrorFromJson(json);
  Map<String, dynamic> toJson() => _$BackendErrorToJson(this);

  String get message => (error?.toString() ?? '');
}
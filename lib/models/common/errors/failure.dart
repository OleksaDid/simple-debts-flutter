import 'package:json_annotation/json_annotation.dart';
import 'package:simpledebts/models/common/errors/field_validation_error.dart';

part 'failure.g.dart';

@JsonSerializable(explicitToJson: true)
class Failure {
  final dynamic error;
  final List<FieldValidationError> fields;

  Failure({
    this.error,
    this.fields
  });

  factory Failure.fromJson(Map<String, dynamic> json) => _$FailureFromJson(json);
  Map<String, dynamic> toJson() => _$FailureToJson(this);

  String get message => (error?.toString() ?? '');
}
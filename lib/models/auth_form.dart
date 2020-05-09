import 'package:json_annotation/json_annotation.dart';

part 'auth_form.g.dart';

@JsonSerializable()
class AuthForm {
  String email;
  String password;

  AuthForm({
    this.email = '',
    this.password = ''
  });

  factory AuthForm.fromJson(Map<String, dynamic> json) => _$AuthFormFromJson(json);
  Map<String, dynamic> toJson() => _$AuthFormToJson(this);
}
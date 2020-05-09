// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_form.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthForm _$AuthFormFromJson(Map<String, dynamic> json) {
  return AuthForm(
    email: json['email'] as String,
    password: json['password'] as String,
  );
}

Map<String, dynamic> _$AuthFormToJson(AuthForm instance) => <String, dynamic>{
      'email': instance.email,
      'password': instance.password,
    };

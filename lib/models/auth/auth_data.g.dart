// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AuthData _$AuthDataFromJson(Map<String, dynamic> json) {
  return AuthData(
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    token: json['token'] as String,
    refreshToken: json['refreshToken'] as String,
  );
}

Map<String, dynamic> _$AuthDataToJson(AuthData instance) => <String, dynamic>{
      'user': instance.user?.toJson(),
      'token': instance.token,
      'refreshToken': instance.refreshToken,
    };

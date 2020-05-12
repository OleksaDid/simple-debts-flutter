import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:simpledebts/models/user/user.dart';

part 'auth_data.g.dart';

@JsonSerializable(explicitToJson: true)
class AuthData {
  final User user;
  final String token;
  final String refreshToken;

  const AuthData({
    @required this.user,
    @required this.token,
    @required this.refreshToken
  });

  factory AuthData.fromJson(Map<String, dynamic> json) => _$AuthDataFromJson(json);
  Map<String, dynamic> toJson() => _$AuthDataToJson(this);
}
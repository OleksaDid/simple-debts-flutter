import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'env.g.dart';

@JsonSerializable()
class Env {
  final String API_URL;

  Env({
    @required this.API_URL
  });

  factory Env.fromJson(Map<String, dynamic> json) => _$EnvFromJson(json);
  Map<String, dynamic> toJson() => _$EnvToJson(this);

}
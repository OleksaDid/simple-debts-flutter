import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class Notification {
  final String title;
  final String body;

  Notification({
    @required this.title,
    @required this.body
  });

  factory Notification.fromJson(Map<String, dynamic> json) => _$NotificationFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationToJson(this);
}
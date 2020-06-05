// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Notification _$NotificationFromJson(Map<String, dynamic> json) {
  return Notification(
    title: json['title'] as String,
    body: json['body'] as String,
  );
}

Map<String, dynamic> _$NotificationToJson(Notification instance) =>
    <String, dynamic>{
      'title': instance.title,
      'body': instance.body,
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'push_notification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PushNotification _$PushNotificationFromJson(Map<String, dynamic> json) {
  return PushNotification(
    notification: json['notification'] == null
        ? null
        : Notification.fromJson(json['notification'] as Map<String, dynamic>),
    data: json['data'] == null
        ? null
        : NotificationData.fromJson(json['data'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$PushNotificationToJson(PushNotification instance) =>
    <String, dynamic>{
      'notification': instance.notification?.toJson(),
      'data': instance.data?.toJson(),
    };

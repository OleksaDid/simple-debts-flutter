import 'package:json_annotation/json_annotation.dart';
import 'package:simpledebts/models/common/push_notification/notification.dart';
import 'package:simpledebts/models/common/push_notification/notification_data.dart';

part 'push_notification.g.dart';

@JsonSerializable(explicitToJson: true)
class PushNotification {
  final Notification notification;
  final NotificationData data;

  PushNotification({
    this.notification,
    this.data
  });

  factory PushNotification.fromJson(Map<String, dynamic> json) => _$PushNotificationFromJson(json);
  Map<String, dynamic> toJson() => _$PushNotificationToJson(this);

}
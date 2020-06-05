import 'package:json_annotation/json_annotation.dart';

part 'notification_data.g.dart';

@JsonSerializable()
class NotificationData {
  final String debtsId;

  NotificationData({
    this.debtsId
  });

  factory NotificationData.fromJson(Map<String, dynamic> json) => _$NotificationDataFromJson(json);
  Map<String, dynamic> toJson() => _$NotificationDataToJson(this);
}
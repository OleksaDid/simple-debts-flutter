import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/models/common/push_notification/push_notification.dart';
import 'package:simpledebts/models/common/route/id_route_argument.dart';
import 'package:simpledebts/screens/debt_screen.dart';
import 'package:simpledebts/services/navigation_service.dart';
import 'package:simpledebts/services/users_service.dart';

class PushNotificationsService {
  final UsersService _usersService = GetIt.instance<UsersService>();

  PushNotificationsService._();

  factory PushNotificationsService() => _instance;

  static final PushNotificationsService _instance = PushNotificationsService._();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  bool _initialized = false;


  Future<void> init() async {
    if (!_initialized) {
      // For iOS request permission first.
      if (Platform.isIOS) {
        _firebaseMessaging.requestNotificationPermissions(IosNotificationSettings());
      }

      _firebaseMessaging.configure(
        onMessage: _handleMessage,
        onBackgroundMessage: _handleBkgMessage,
        onLaunch: _handleLaunch,
        onResume: _handleResume,
      );

      await _sendDeviceToken();

      _initialized = true;
    }
  }

  static Future<void> _handleMessage(Map<String, dynamic> message) async {
    print('M: ${message.toString()}');
  }

  static Future<void> _handleBkgMessage(Map<String, dynamic> message) async {
    _basicNotificationHandle(message);
  }

  static Future<void> _handleLaunch(Map<String, dynamic> message) async {
    _basicNotificationHandle(message);
  }

  static Future<void> _handleResume(Map<String, dynamic> message) async {
    _basicNotificationHandle(message);
  }


  Future<void> _sendDeviceToken() async {
    String token = await _firebaseMessaging.getToken();
    return _usersService.pushDeviceToken(token);
  }

  static _basicNotificationHandle(Map<String, dynamic> message) {
    final debtId = message['data'] != null
        ? message['data']['debtsId']
        : null;

    if(debtId != null) {
      GetIt.instance<NavigationService>().navigateTo(
          DebtScreen.routeName,
          arguments: IdRouteArgument(debtId)
      );
    }
  }
}
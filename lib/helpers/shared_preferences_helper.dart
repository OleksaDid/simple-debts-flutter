import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:simpledebts/models/auth/auth_data.dart';

class SharedPreferencesHelper {
  static final _authDataKey = 'authData';

  static Future<AuthData> getAuthData() async {
    final prefs = await SharedPreferences.getInstance();
    if(prefs.containsKey(_authDataKey)) {
      final data = prefs.getString(_authDataKey);
      final json = Map<String, dynamic>.from(jsonDecode(data));
      return AuthData.fromJson(json);
    }
    return null;
  }

  static Future<void> saveAuthData(AuthData authData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = jsonEncode(authData.toJson());
      return prefs.setString(_authDataKey, data);
    } catch(error) {
      print(error);
      throw error;
    }
  }

  static Future<void> removeAllData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.clear();
    } catch(error) {
      print(error);
      throw error;
    }
  }
}
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simpledebts/helpers/env_helper.dart';
import 'package:simpledebts/mixins/api_service.dart';
import 'package:simpledebts/models/auth_data.dart';
import 'package:simpledebts/models/auth_form.dart';
import 'package:simpledebts/screens/auth_screen.dart';

class AuthProvider with ChangeNotifier, ApiService {
  final _deviceDataKey = 'authData';
  final String baseUrl = EnvHelper.env.API_URL;

  AuthData _authData;

  AuthData get authData {
    return _authData;
  }

  Map<String, String> get authHeaders {
    return _getAuthBearerHeader(_authData.token);
  }

  bool get isAuthenticated {
    return _authData != null;
  }

  
  Future<void> login(AuthForm authForm) {
    return _authenticate('/login/local', authForm);
  }
  
  Future<void> signUp(AuthForm authForm) {
    return _authenticate('/sign_up/local', authForm);
  }

  void logout(BuildContext context) {
    _authData = null;
    _removeDataFromDevice();
    notifyListeners();
    Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
  }

  Future<void> updateAccessToken() async {
    try {
      final url = '$baseUrl/login/refresh_token';
      final Response response = await get(url,
          headers: _getAuthBearerHeader(_authData.refreshToken)
      );
      if(response.statusCode >= 400) {
        handleResponseError(response);
      }
      _updateAuthData(response.body);
    } catch(error) {
      handleError(error);
    }
  }

  Future<void> facebookLogin(String token) async {
    try {
      final url = '$baseUrl/login/facebook';
      final response = await get(url,
        headers: _getAuthBearerHeader(token)
      );
      if(response.statusCode >= 400) {
        handleResponseError(response);
      }
      _updateAuthData(response.body);
    } catch(error) {
      handleError(error);
    }
  }

  Future<bool> autoLogin() async {
    if(_authData != null) {
      return true;
    }
    try {
      final prefs = await SharedPreferences.getInstance();
      if(prefs.containsKey(_deviceDataKey)) {
        final data = prefs.getString(_deviceDataKey);
        _authData = AuthData.fromJson(jsonDecode(data));
        final isValidToken = await _checkLoginStatus();
        if(isValidToken) {
          _updateAuthData(jsonDecode(data));
          return true;
        } else {
          try {
            await updateAccessToken();
            return true;
          } catch(error) {
            return false;
          }
        }
      } else {
        return false;
      }
    } catch(error) {
      print(error);
      throw error;
    }
  }


  Future<void> _authenticate(String urlPath, AuthForm authForm) async {
    try {
      final url = baseUrl + urlPath;
      final Response response = await post(url, 
        body: authForm.toJson()
      );
      if(response.statusCode >= 400) {
        handleResponseError(response);
      }
      _updateAuthData(response.body);
    } catch(error) {
      handleError(error);
    }
  }

  void _updateAuthData(String json) {
    _authData = AuthData.fromJson(jsonDecode(json));
    _saveDataToDevice();
    notifyListeners();
  }

  Future<bool> _checkLoginStatus() async {
    if(_authData == null) {
      return false;
    } else {
      try {
        final url = '$baseUrl/login/status';
        final Response response = await get(url,
            headers: authHeaders
        );
        return response.statusCode < 400;
      } catch(error) {
        handleError(error);
        return false;
      }
    }
  }

  Map<String, String> _getAuthBearerHeader(String token) {
    return {
      'Authorization': 'bearer $token'
    };
  }

  Future<void> _saveDataToDevice() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = jsonEncode(_authData.toJson());
      prefs.setString(_deviceDataKey, data);
    } catch(error) {
      print(error);
      throw error;
    }
  }

  Future<void> _removeDataFromDevice() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      return prefs.clear();
    } catch(error) {
      print(error);
      throw error;
    }
  }
}
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/helpers/shared_preferences_helper.dart';
import 'package:simpledebts/mixins/api_service_with_auth_headers.dart';
import 'package:simpledebts/models/auth/auth_data.dart';
import 'package:simpledebts/models/auth/auth_form.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/screens/auth_screen.dart';

class AuthProvider extends ApiServiceWithAuthHeaders with ChangeNotifier {

  AuthData _authData;

  AuthData get authData {
    return _authData;
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
    SharedPreferencesHelper.removeAllData();
    notifyListeners();
    Navigator.of(context).pushReplacementNamed(AuthScreen.routeName);
  }

  Future<void> facebookLogin() async {
    final FacebookLoginResult loginResult = await FacebookLogin().logIn(['public_profile', 'email']);

    switch (loginResult.status) {
      case FacebookLoginStatus.loggedIn:
        try {
          final url = '/login/facebook';
          final response = await http().get(url, options: Options(
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer ' + loginResult.accessToken.token
            }
          ));
          _updateAuthData(AuthData.fromJson(response.data));
        } on DioError catch(error) {
          ErrorHelper.handleDioError(error);
        } catch(error) {
          ErrorHelper.handleError(error);
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        return;
        break;
      case FacebookLoginStatus.error:
        throw loginResult.errorMessage;
        break;
    }
  }

  Future<bool> autoLogin() async {
    if(_authData != null) {
      return true;
    }
    try {
      final authData = await SharedPreferencesHelper.getAuthData();
      if(authData != null) {
        _authData = authData;
        final isValidToken = await _checkLoginStatus();
        if(isValidToken) {
          _updateAuthData(authData);
          return true;
        } else {
          try {
            await refreshToken();
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

  void updateUserInformation(User user) {
    _authData = AuthData(
      token: _authData.token,
      refreshToken: _authData.refreshToken,
      user: user
    );
    _updateAuthData(_authData);
  }


  void _updateAuthData(AuthData authData) {
    _authData = authData;
    SharedPreferencesHelper.saveAuthData(_authData);
    notifyListeners();
  }

  Future<void> _authenticate(String urlPath, AuthForm authForm) async {
    try {
      final Response response = await http().post(urlPath,
        data: authForm.toJson()
      );
      _updateAuthData(AuthData.fromJson(response.data));
    } on DioError catch(error) {
      ErrorHelper.handleDioError(error);
    } catch(error) {
      ErrorHelper.handleError(error);
    }
  }

  Future<bool> _checkLoginStatus() async {
    if(_authData == null) {
      return false;
    } else {
      try {
        final url = '/login/status';
        final Response response = await http().get(url);
        return response.statusCode < 400;
      } catch(error) {
        ErrorHelper.handleError(error);
        return false;
      }
    }
  }
}
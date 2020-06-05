import 'dart:io';

import 'package:dio/dio.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/helpers/shared_preferences_helper.dart';
import 'package:simpledebts/mixins/http_service_use.dart';
import 'package:simpledebts/models/auth/auth_data.dart';
import 'package:simpledebts/models/auth/auth_form.dart';
import 'package:simpledebts/models/common/errors/failure.dart';

class AuthService with HttpServiceUse {

  Future<AuthData> login(AuthForm authForm) {
    return _authenticate('/login/local', authForm);
  }
  
  Future<AuthData> signUp(AuthForm authForm) {
    return _authenticate('/sign_up/local', authForm);
  }

  Future<AuthData> facebookLogin() async {
    final FacebookLoginResult loginResult = await FacebookLogin().logIn(['public_profile', 'email']);

    switch (loginResult.status) {
      case FacebookLoginStatus.loggedIn:
        try {
          final url = '/login/facebook';
          final response = await http.get(url, options: Options(
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer ' + loginResult.accessToken.token
            }
          ));
          return AuthData.fromJson(response.data);
        } on DioError catch(error) {
          throw ErrorHelper.handleDioError(error);
        }
        break;
      case FacebookLoginStatus.cancelledByUser:
        return null;
        break;
      case FacebookLoginStatus.error:
        throw Failure(error: loginResult.errorMessage);
        break;
    }
  }

  Future<AuthData> autoLogin() async {
    try {
      final authData = await SharedPreferencesHelper.getAuthData();
      if(authData != null) {
        final isValidToken = await _checkLoginStatus(authData);
        if(isValidToken == true) {
          return authData;
        } else {
          try {
            return refreshToken(authData);
          } on DioError catch(error) {
            ErrorHelper.handleDioError(error);
            return null;
          } catch(error) {
            ErrorHelper.logError(error);
            return null;
          }
        }
      } else {
        return null;
      }
    } on DioError catch(error) {
      ErrorHelper.handleDioError(error);
      return null;
    } catch(error) {
      ErrorHelper.logError(error);
      return null;
    }
  }
  
  Future<AuthData> refreshToken(AuthData authData) async {
    try {
      if(authData != null) {
        print('refreshing token...');
        final response = await http.get('/login/refresh_token', options: Options(
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer ' + authData.refreshToken
            }
        ));
        print('token updated');
        return AuthData.fromJson(response.data);
      }
      return null;
    } on DioError catch(error) {
      ErrorHelper.handleDioError(error);
      return null;
    } catch(error) {
      ErrorHelper.logError(error);
      return null;
    }
  }


  Future<AuthData> _authenticate(String urlPath, AuthForm authForm) async {
    try {
      final Response response = await http.post(urlPath,
        data: authForm.toJson()
      );
      final authData = AuthData.fromJson(response.data);
      Crashlytics.instance.setUserIdentifier(authData.user.id);
      Crashlytics.instance.setUserName(authData.user.name);
      return authData;
    } on DioError catch(error) {
      throw ErrorHelper.handleDioError(error);
    }
  }

  Future<bool> _checkLoginStatus(AuthData authData) async {
    if(authData == null) {
      return false;
    } else {
      try {
        final url = '/login/status';
        await http.get(url, options: Options(
          headers: {
            HttpHeaders.authorizationHeader: 'Bearer ' + authData.token
          }
        ));
        return true;
      } on DioError catch(error) {
        ErrorHelper.handleDioError(error);
        return false;
      } catch(error) {
        ErrorHelper.logError(error);
        return false;
      }
    }
  }
}
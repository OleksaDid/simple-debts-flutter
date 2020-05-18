import 'dart:io';

import 'package:dio/dio.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/helpers/shared_preferences_helper.dart';
import 'package:simpledebts/mixins/api_service.dart';
import 'package:simpledebts/models/auth/auth_data.dart';

class ApiServiceWithAuthHeaders extends ApiService {

  @override
  Dio http() {
    final http = super.http();
    http.interceptors.add(
      InterceptorsWrapper(onRequest: (RequestOptions requestOptions) async {
        http.interceptors.requestLock.lock();
        final authData = await _getAuthData();
        if (authData != null) {
          requestOptions.headers[HttpHeaders.authorizationHeader] = 'Bearer ' + authData.token;
        }
        http.interceptors.requestLock.unlock();
        return requestOptions;
      }, onError: (DioError error) async {
        // TODO: log error
        if (error.response?.statusCode == 401) {
          http.interceptors.requestLock.lock();
          http.interceptors.responseLock.lock();
          RequestOptions options = error.response.request;
          final authData = await refreshToken();
          options.headers[HttpHeaders.authorizationHeader] = "Bearer " + authData.token;

          http.interceptors.requestLock.unlock();
          http.interceptors.responseLock.unlock();
          return http.request(options.path,options: options);
        } else {
          return error;
        }
      }),
    );
    return http;
  }

  Future<AuthData> refreshToken() async {
    try {
      final authData = await _getAuthData();
      if(authData != null) {
        final response = await super.http().get('/login/refresh_token', options: Options(
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer ' + authData.refreshToken
            }
        ));
        if(response.statusCode >= 400) {
          ErrorHelper.handleResponseError(response);
        }
        final updatedAuthData = AuthData.fromJson(response.data);
        _updateAuthData(updatedAuthData);
        return updatedAuthData;
      }
    } catch(error) {
      ErrorHelper.handleError(error);
    }
    return null;
  }


  Future<void> _updateAuthData(AuthData authData) {
    return SharedPreferencesHelper.saveAuthData(authData);
  }

  Future<AuthData> _getAuthData() {
    return SharedPreferencesHelper.getAuthData();
  }
}
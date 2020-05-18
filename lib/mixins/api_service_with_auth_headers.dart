import 'dart:io';

import 'package:dio/dio.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/helpers/shared_preferences_helper.dart';
import 'package:simpledebts/mixins/api_service.dart';
import 'package:simpledebts/models/auth/auth_data.dart';

class ApiServiceWithAuthHeaders extends ApiService {

  // TODO: one instance of Dio, so interceptors can work properly
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
          print(error.request.path);
          print('token expired, need to update');
          http.interceptors.requestLock.lock();
          http.interceptors.responseLock.lock();
          RequestOptions options = error.response.request;
          final authData = await refreshToken();
          http.interceptors.requestLock.unlock();
          http.interceptors.responseLock.unlock();
          if(authData != null) {
            options.headers[HttpHeaders.authorizationHeader] = "Bearer " + authData.token;
            print('token sucessfully updated, resuming request');
            return http.request(options.path,options: options);
          } else {
            print('refresh failed');
            return error;
          }

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
        print('refreshing token...');
        final response = await super.http().get('/login/refresh_token', options: Options(
            headers: {
              HttpHeaders.authorizationHeader: 'Bearer ' + authData.refreshToken
            }
        ));
        final updatedAuthData = AuthData.fromJson(response.data);
        await _updateAuthData(updatedAuthData);
        print('token updated');
        return updatedAuthData;
      }
    } on DioError catch(error) {
      ErrorHelper.handleDioError(error);
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
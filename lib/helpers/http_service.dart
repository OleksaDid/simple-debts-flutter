import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:simpledebts/helpers/env_helper.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/helpers/shared_preferences_helper.dart';
import 'package:simpledebts/models/auth/auth_data.dart';

class HttpService with ChangeNotifier {
  @protected
  final String baseUrl = EnvHelper.env.API_URL;

  Dio baseHttp;
  Dio http;


  HttpService._privateConstructor() {
    _init();
  }

  static final HttpService _instance = HttpService._privateConstructor();

  static HttpService get instance => _instance;


  Future<AuthData> refreshToken() async {
    try {
      final authData = await _getAuthData();
      if(authData != null) {
        print('refreshing token...');
        final response = await baseHttp.get('/login/refresh_token', options: Options(
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


  void _init() {
    baseHttp = _createBaseHttp();
    http = _createHttp();
  }

  Dio _createBaseHttp() {
    return Dio(BaseOptions(
        baseUrl: baseUrl,
        responseType: ResponseType.json,
        contentType: 'application/json'
    ));
  }

  Dio _createHttp() {
    final http = _createBaseHttp();
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

  Future<void> _updateAuthData(AuthData authData) {
    return SharedPreferencesHelper.saveAuthData(authData);
  }

  Future<AuthData> _getAuthData() {
    return SharedPreferencesHelper.getAuthData();
  }
}
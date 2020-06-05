import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/models/common/errors/failure.dart';
import 'package:simpledebts/services/http_service.dart';
import 'package:simpledebts/store/auth.store.dart';


class HttpAuthService {
  final httpService = GetIt.instance<HttpService>();
  final authStore = GetIt.instance<AuthStore>();

  Dio http;


  HttpAuthService() {
    _init();
  }


  void _init() {
    http = _createHttp();
  }

  Dio _createHttp() {
    final http = httpService.createBaseHttp();
    http.interceptors.add(
      InterceptorsWrapper(
        onRequest: (requestOptions) => _addAccessToken(http, requestOptions),
        onError: (error) => _onError(http, error)
      ),
    );
    return http;
  }


  dynamic _addAccessToken(Dio http, RequestOptions requestOptions) async {
    http.interceptors.requestLock.lock();
    final authData = authStore.authData;
    if (authData != null) {
      requestOptions.headers[HttpHeaders.authorizationHeader] = 'Bearer ' + authData.token;
    }
    http.interceptors.requestLock.unlock();
    return requestOptions;
  }

  dynamic _onError(Dio http, DioError error) async {
    // TODO: log error
    final failure = error?.response?.data != null
        ? Failure.fromJson(error.response.data)
        : null;
    final isInvalidToken = failure?.error == 'Invalid Token';

    if (error.response?.statusCode == 401 || isInvalidToken) {
      print(error.request.path);
      print('token expired, need to update');

      http.interceptors.requestLock.lock();
      http.interceptors.responseLock.lock();

      final authData = await authStore.refreshToken();

      http.interceptors.requestLock.unlock();
      http.interceptors.responseLock.unlock();

      if(authData != null) {
        RequestOptions options = error.response.request;
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
  }
}
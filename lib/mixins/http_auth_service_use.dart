import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/helpers/http_auth_service.dart';

mixin HttpAuthServiceUse {
  @protected
  final HttpAuthService httpService = GetIt.instance<HttpAuthService>();


  Dio get http {
    return httpService.http;
  }
}
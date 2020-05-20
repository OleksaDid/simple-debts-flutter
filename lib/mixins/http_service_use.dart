import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/services/http_service.dart';

mixin HttpServiceUse {
  @protected
  final HttpService httpService = GetIt.instance<HttpService>();


  Dio get http {
    return httpService.http;
  }
}
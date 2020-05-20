import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:simpledebts/helpers/env_helper.dart';

class HttpService {
  @protected
  final String baseUrl = EnvHelper.env.API_URL;

  Dio http;


  HttpService() {
    _init();
  }


  Dio createBaseHttp() {
    return Dio(BaseOptions(
        baseUrl: baseUrl,
        responseType: ResponseType.json,
        contentType: 'application/json'
    ));
  }


  void _init() {
    http = createBaseHttp();
  }
}
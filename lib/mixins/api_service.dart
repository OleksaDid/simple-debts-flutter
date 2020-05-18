import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:simpledebts/helpers/env_helper.dart';

abstract class ApiService {
  @protected
  final String baseUrl = EnvHelper.env.API_URL;

  Dio http() {
    return Dio(BaseOptions(
      baseUrl: baseUrl,
      responseType: ResponseType.json,
      contentType: 'application/json'
    ));
  }
}
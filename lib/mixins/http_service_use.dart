import 'package:flutter/material.dart';
import 'package:simpledebts/helpers/http_service.dart';

mixin HttpServiceUse {
  @protected
  final HttpService httpService = HttpService.instance;

  get baseHttp {
    return httpService.baseHttp;
  }

  get http {
    return httpService.http;
  }
}
import 'package:flutter/material.dart';
import 'package:simpledebts/helpers/env_helper.dart';

abstract class ApiService {
  @protected
  final String baseUrl = EnvHelper.env.API_URL;
}
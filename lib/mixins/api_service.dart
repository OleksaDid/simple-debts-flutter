import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

class ApiService {

  @protected
  Error handleResponseError(Response response) {
    // TODO: error handling
    final body = jsonDecode(response.body);
    final error = body['error'] ?? 'Unknown error';
    print(response.request.url);
    print(response.request.headers);
    print('HTTP ERROR: ${response.statusCode} - $error');
    throw error;
  }

  @protected
  Error handleError(Error error) {
    print('ERROR: ${error.toString()}');
    throw error;
  }
}
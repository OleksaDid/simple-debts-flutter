import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorHelper {

  static Error handleResponseError(Response response) {
    // TODO: log error
    final body = jsonDecode(response.data);
    final error = body['error'] ?? 'Unknown error';
    print(response.request.path);
    print(response.request.headers);
    print('HTTP ERROR: ${response.statusCode} - $error');
    throw error;
  }


  static Error handleError(Error error) {
    // TODO: log error
    print('ERROR: ${error.toString()}');
    throw error;
  }

  static showErrorSnackBar(BuildContext context, [String error = 'Something went wrong. Try again later']) {
    print(error);
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(error),
      backgroundColor: Theme.of(context).errorColor,
    ));
  }
}
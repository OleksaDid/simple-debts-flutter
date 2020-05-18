import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simpledebts/models/common/errors/backend_error.dart';

class ErrorHelper {

  static  handleDioError(DioError error) {
    // TODO: log error
    if(error.response != null) {
      final backendError = BackendError.fromJson(error.response.data);
      print('PATH: ${error.request.path}');
      print('HEADERS: ${error.request.headers}');
      print('BACKEND ERROR: ${error.response.statusCode} - ${backendError.message}');
      if(backendError.fields != null && backendError.fields.length > 0) {
        print('VALIDATION ERRORS: ${backendError.fields.toString()}');
      }
      throw error;
    } else {
      print('REQUEST: ${error.request}');
      print('ERROR: ${error.message}');
    }
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
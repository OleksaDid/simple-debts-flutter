import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:simpledebts/models/common/errors/failure.dart';

class ErrorHelper {

  static Failure handleDioError(DioError error) {
    // TODO: log error
    switch (error.type) {
      case DioErrorType.RESPONSE:
        if(error.response.statusCode >= 500) {
          print('REQUEST: ${error.request}');
          print('SERVER ERROR: ${error.response.statusCode} - ${error.message}');
          return Failure(error: 'Something went wrong, try again later...');
        }
        final failure = Failure.fromJson(error.response.data);
        print('PATH: ${error.request.path}');
        print('HEADERS: ${error.request.headers}');
        print('BACKEND ERROR: ${error.response.statusCode} - ${failure.message}');
        if(failure.fields != null && failure.fields.length > 0) {
          print('VALIDATION ERRORS: ${failure.fields.toString()}');
        }
        return failure;
        break;

      default:
        print('REQUEST: ${error.request}');
        print('SERVER ERROR: ${error.message}');
        return Failure(error: 'Something went wrong, try again later...');
        break;
    }
  }

  static Failure handleError(Error error) {
    print('UNEXPECTED ERROR: ${error.toString()}');
  }


  static void showErrorSnackBar(BuildContext context, [String error = 'Something went wrong. Try again later']) {
    Scaffold.of(context).hideCurrentSnackBar();
    Scaffold.of(context).showSnackBar(SnackBar(
      content: Text(error),
      backgroundColor: Theme.of(context).errorColor,
    ));
  }
}
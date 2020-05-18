import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/http_service_use.dart';

class OperationsProvider with ChangeNotifier, HttpServiceUse {

  Future<void> createOperation({
    @required String id,
    @required String description,
    @required String moneyReceiver,
    @required double moneyAmount
  }) async {
    try {
      final url = '/operations';
      final body = {
        'debtsId': id,
        'description': description,
        'moneyReceiver': moneyReceiver,
        'moneyAmount': moneyAmount
      };
      await http.post(url, data: body);
    } on DioError catch(error) {
      ErrorHelper.handleDioError(error);
    }
  }

  Future<void> deleteOperation(String id) async {
    try {
      final url = '/operations/$id';
      await http.delete(url);
    } on DioError catch(error) {
      ErrorHelper.handleDioError(error);
    }
  }

  Future<void> acceptOperation(String id) async {
    try {
      final url = '/operations/$id/creation/accept';
      await http.post(url);
    } on DioError catch(error) {
      ErrorHelper.handleDioError(error);
    }
  }

  Future<void> declineOperation(String id) async {
    try {
      final url = '/operations/$id/creation/decline';
      await http.post(url);
    } on DioError catch(error) {
      ErrorHelper.handleDioError(error);
    }
  }

}
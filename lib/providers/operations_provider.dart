import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/api_service_with_auth_headers.dart';

class OperationsProvider extends ApiServiceWithAuthHeaders with ChangeNotifier {

  Future<void> createOperation({
    @required String id,
    @required String description,
    @required String moneyReceiver,
    @required double moneyAmount
  }) async {
    final url = '$baseUrl/operations';
    final body = jsonEncode({
      'debtsId': id,
      'description': description,
      'moneyReceiver': moneyReceiver,
      'moneyAmount': moneyAmount
    });
    final response = await post(url, headers: {
      'content-type': 'application/json',
      ...authHeaders
    }, body: body);
    if(response.statusCode >= 400) {
      print(response.body);
      print('ERRROR');
      ErrorHelper.handleResponseError(response);
      return null;
    }
  }

  Future<void> deleteOperation(String id) async {
    final url = '$baseUrl/operations/$id';
    final response = await delete(url, headers: authHeaders);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
  }

  Future<void> acceptOperation(String id) async {
    final url = '$baseUrl/operations/$id/creation/accept';
    final response = await post(url, headers: authHeaders);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
  }

  Future<void> declineOperation(String id) async {
    final url = '$baseUrl/operations/$id/creation/decline';
    final response = await post(url, headers: authHeaders);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
  }

}
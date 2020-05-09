import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/api_service_with_auth_headers.dart';
import 'package:simpledebts/models/operation.dart';

class OperationsProvider extends ApiServiceWithAbstractHeaders with ChangeNotifier {

  Future<Operation> createOperation(String id, String description, String moneyReceiver, double moneyAmount) async {
    final url = '$baseUrl/operations';
    final response = await post(url, headers: authHeaders, body: {
      'debtsId': id,
      'description': description,
      'moneyReceiver': moneyReceiver,
      'moneyAmount': moneyAmount
    });
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
    return Operation.fromJson(jsonDecode(response.body));
  }

  Future<void> deleteOperation(String id) async {
    final url = '$baseUrl/operations/$id';
    final response = await delete(url, headers: authHeaders);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
  }

  Future<Operation> acceptOperation(String id) async {
    final url = '$baseUrl/operations/$id/creation/accept';
    final response = await post(url, headers: authHeaders);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
    return Operation.fromJson(jsonDecode(response.body));
  }

  Future<void> declineOperation(String id) async {
    final url = '$baseUrl/operstions/$id/creation/decline';
    final response = await post(url, headers: authHeaders);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
  }

}
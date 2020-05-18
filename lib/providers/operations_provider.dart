import 'package:flutter/cupertino.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/api_service_with_auth_headers.dart';

class OperationsProvider extends ApiServiceWithAuthHeaders with ChangeNotifier {

  Future<void> createOperation({
    @required String id,
    @required String description,
    @required String moneyReceiver,
    @required double moneyAmount
  }) async {
    final url = '/operations';
    final body = {
      'debtsId': id,
      'description': description,
      'moneyReceiver': moneyReceiver,
      'moneyAmount': moneyAmount
    };
    final response = await http().post(url, data: body);
    if(response.statusCode >= 400) {
      print(response.data);
      print('ERRROR');
      ErrorHelper.handleResponseError(response);
      return null;
    }
  }

  Future<void> deleteOperation(String id) async {
    final url = '/operations/$id';
    final response = await http().delete(url);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
  }

  Future<void> acceptOperation(String id) async {
    final url = '/operations/$id/creation/accept';
    final response = await http().post(url);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
  }

  Future<void> declineOperation(String id) async {
    final url = '/operations/$id/creation/decline';
    final response = await http().post(url);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
  }

}
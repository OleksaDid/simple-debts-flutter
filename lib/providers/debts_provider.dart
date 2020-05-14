import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/api_service_with_auth_headers.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/models/debts/debt_list.dart';

class DebtsProvider extends ApiServiceWithAuthHeaders with ChangeNotifier {
  DebtList _debtList;

  DebtList get debtList {
    return _debtList;
  }

  Future<void> fetchAndSetDebtList() async {
    final url = '$baseUrl/debts';
    final Response response = await get(url, headers: authHeaders);
    if(response.statusCode >= 400) {
      return ErrorHelper.handleResponseError(response);
    }
    _debtList = DebtList.fromJson(jsonDecode(response.body));
    notifyListeners();
  }

  Debt getDebt(String id) {
    return _debtList?.debts?.firstWhere(
      (debt) => debt.id == id,
      orElse: () => null
    );
  }

  Future<Debt> fetchDebt(String id) async {
    final url = '$baseUrl/debts/$id';
    final Response response = await get(url, headers: authHeaders);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
    final Debt debt = Debt.fromJson(jsonDecode(response.body));
    _updateDebtById(id, debt);
    return debt;
  }

  Future<bool> requestDebtDelete(BuildContext context) {
    return showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)
          ),
          title: Text('Delete this debt?'),
          actions: [
            FlatButton(
              child: Text('NO'),
              textColor: Theme.of(context).accentColor,
              onPressed: () => Navigator.of(context).pop(false),
            ),
            FlatButton(
              child: Text('YES'),
              textColor: Theme.of(context).accentColor,
              onPressed: () => Navigator.of(context).pop(true),
            ),
          ],
        )
    );
  }

  Future<void> deleteDebt(String id) async {
    final debt = getDebt(id);
    final debtTypePath = debt.type == DebtAccountType.SINGLE_USER ? 'single' : 'multiple';
    final url = '$baseUrl/debts/$debtTypePath/$id';
    final Response response = await delete(url, headers: authHeaders);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
    _removeDebtById(id);
  }

  Future<Debt> createMultipleDebt(String userId, String currency) async {
    final url = '$baseUrl/debts/multiple';
    final Response response = await post(url,
      body: {
        'userId': userId,
        'currency': currency
      },
      headers: authHeaders
    );
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
    final Debt debt = Debt.fromJson(jsonDecode(response.body));
    _addDebt(debt);
    return debt;
  }

  Future<Debt> createSingleDebt(String userName, String currency) async {
    final url = '$baseUrl/debts/single';
    final Response response = await post(url,
      body: {
        'userName': userName,
        'currency': currency
      },
      headers: authHeaders
    );
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
    final Debt debt = Debt.fromJson(jsonDecode(response.body));
    _addDebt(debt);
    return debt;
  }

  Future<void> acceptMultipleDebtCreation(String id) async {
    final url = '$baseUrl/debts/multiple/$id/creation/accept';
    final response = await post(url, headers: authHeaders);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
    final Debt debt = Debt.fromJson(jsonDecode(response.body));
    _updateDebtById(id, debt);
  }

  Future<void> declineMultipleDebtCreation(String id) async {
    final url = '$baseUrl/debts/multiple/$id/creation/decline';
    final response = await post(url, headers: authHeaders);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
  }

  Future<void> acceptAllOperations(String id) async {
    final url = '$baseUrl/debts/multiple/$id/accept_all_operations';
    final response = await post(url, headers: authHeaders);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
    final Debt debt = Debt.fromJson(jsonDecode(response.body));
    _updateDebtById(id, debt);
  }

  Future<void> acceptUserDeletedFromDebt(String id) async {
    final url = '$baseUrl/debts/single/$id/i_love_lsd';
    final response = await post(url, headers: authHeaders);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
    final Debt debt = Debt.fromJson(jsonDecode(response.body));
    _updateDebtById(id, debt);
  }

  Future<void> connectUserToSingleDebt(String id, String userId) async {
    final url = '$baseUrl/debts/single/$id/connect_user';
    final response = await post(url, headers: authHeaders, body: {
      'userId': userId
    });
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
    final Debt debt = Debt.fromJson(jsonDecode(response.body));
    _updateDebtById(id, debt);
  }

  Future<void> acceptUserConnecting(String id) async {
    final url = '$baseUrl/debts/single/$id/connect_user/accept';
    final response = await post(url, headers: authHeaders);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
    final Debt debt = Debt.fromJson(jsonDecode(response.body));
    _updateDebtById(id, debt);
  }

  Future<void> declineUserConnecting(String id) async {
    final url = '$baseUrl/debts/single/$id/connect_user/decline';
    final response = await post(url, headers: authHeaders);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
  }


  void _addDebt(Debt debt) {
    _debtList.debts.insert(0, debt);
    notifyListeners();
  }

  void _updateDebtById(String id, Debt debt) {
    final debtIndex = _debtList.debts.indexWhere((debt) => debt.id == id);
    _debtList.debts[debtIndex] = debt;
    notifyListeners();
  }

  void _removeDebtById(String id) {
    final debtIndex = _debtList.debts.indexWhere((debt) => debt.id == id);
    _debtList.debts.removeAt(debtIndex);
    notifyListeners();
  }

}
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
    return _debtList?.debts?.firstWhere((debt) => debt.id == id);
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

  Future<void> deleteDebt(String id) async {
    var debtInfo = _removeDebtById(id);

    try {
      final debtTypePath = debtInfo.values.elementAt(0).type == DebtAccountType.SINGLE_USER ? 'single' : 'multiple';
      final url = '$baseUrl/debts/$debtTypePath/$id';
      final Response response = await delete(url, headers: authHeaders);
      if(response.statusCode >= 400) {
        ErrorHelper.handleResponseError(response);
        _restoreDeletedDebt(debtInfo);
        return null;
      }
      debtInfo = null;
    } catch(error) {
      _restoreDeletedDebt(debtInfo);
      ErrorHelper.handleError(error);
    }
  }

  Future<String> createMultipleDebt(String userId, String currency) async {
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
    return debt.id;
  }

  Future<String> createSingleDebt(String userName, String currency) async {
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
    return debt.id;
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
    var deletedDebtInfo = _removeDebtById(id);

    try {
      final url = '$baseUrl/debts/multiple/$id/creation/decline';
      final response = await post(url, headers: authHeaders);
      if(response.statusCode >= 400) {
        ErrorHelper.handleResponseError(response);
        _restoreDeletedDebt(deletedDebtInfo);
        return null;
      }
      deletedDebtInfo = null;
    } catch(error) {
      ErrorHelper.handleError(error);
      _restoreDeletedDebt(deletedDebtInfo);
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
    var deletedDebtInfo = _removeDebtById(id);

    try {
      final url = '$baseUrl/debts/single/$id/connect_user/decline';
      final response = await post(url, headers: authHeaders);
      if(response.statusCode >= 400) {
        ErrorHelper.handleResponseError(response);
        _restoreDeletedDebt(deletedDebtInfo);
        return null;
      }
      deletedDebtInfo = null;
    } catch(error) {
      ErrorHelper.handleError(error);
      _restoreDeletedDebt(deletedDebtInfo);
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

  Map<int, Debt> _removeDebtById(String id) {
    final debtIndex = _debtList.debts.indexWhere((debt) => debt.id == id);
    Debt debt = _debtList.debts[debtIndex];
    _debtList.debts.removeAt(debtIndex);
    notifyListeners();
    return {
      debtIndex: debt
    };
  }

  _restoreDeletedDebt(Map<int, Debt> debtInfo) {
    _debtList.debts[debtInfo.keys.elementAt(0)] = debtInfo.values.elementAt(0);
    notifyListeners();
  }

}
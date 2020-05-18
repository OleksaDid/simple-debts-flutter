import 'package:flutter/material.dart';
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
    final url = '/debts';
    final response = await http().get(url);
    if(response.statusCode >= 400) {
      return ErrorHelper.handleResponseError(response);
    }
    _debtList = DebtList.fromJson(response.data);
    notifyListeners();
  }

  Debt getDebt(String id) {
    return _debtList?.debts?.firstWhere(
      (debt) => debt.id == id,
      orElse: () => null
    );
  }

  Future<Debt> fetchDebt(String id) async {
    final url = '/debts/$id';
    final response = await http().get(url);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
    final Debt debt = Debt.fromJson(response.data);
    _updateDebtById(id, debt);
    return debt;
  }

  Future<void> deleteDebt(String id) async {
    final debt = getDebt(id);
    final debtTypePath = debt.type == DebtAccountType.SINGLE_USER ? 'single' : 'multiple';
    final url = '/debts/$debtTypePath/$id';
    final response = await http().delete(url);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
    _removeDebtById(id);
  }

  Future<Debt> createMultipleDebt(String userId, String currency) async {
    final url = '/debts/multiple';
    final response = await http().post(url,
      data: {
        'userId': userId,
        'currency': currency
      },
    );
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
    final Debt debt = Debt.fromJson(response.data);
    _addDebt(debt);
    return debt;
  }

  Future<Debt> createSingleDebt(String userName, String currency) async {
    final url = '/debts/single';
    final response = await http().post(url,
      data: {
        'userName': userName,
        'currency': currency
      },
    );
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
    final Debt debt = Debt.fromJson(response.data);
    _addDebt(debt);
    return debt;
  }

  Future<void> acceptMultipleDebtCreation(String id) async {
    final url = '/debts/multiple/$id/creation/accept';
    final response = await http().post(url);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
    final Debt debt = Debt.fromJson(response.data);
    _updateDebtById(id, debt);
  }

  Future<void> declineMultipleDebtCreation(String id) async {
    final url = '/debts/multiple/$id/creation/decline';
    final response = await http().post(url);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
  }

  Future<void> acceptAllOperations(String id) async {
    final url = '/debts/multiple/$id/accept_all_operations';
    final response = await http().post(url);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
    final Debt debt = Debt.fromJson(response.data);
    _updateDebtById(id, debt);
  }

  Future<void> acceptUserDeletedFromDebt(String id) async {
    final url = '/debts/single/$id/i_love_lsd';
    final response = await http().post(url);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
    final Debt debt = Debt.fromJson(response.data);
    _updateDebtById(id, debt);
  }

  Future<void> connectUserToSingleDebt(String id, String userId) async {
    final url = '/debts/single/$id/connect_user';
    final response = await http().post(url, data: {
      'userId': userId
    });
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
    final Debt debt = Debt.fromJson(response.data);
    _updateDebtById(id, debt);
  }

  Future<void> acceptUserConnecting(String id) async {
    final url = '/debts/single/$id/connect_user/accept';
    final response = await http().post(url);
    if(response.statusCode >= 400) {
      ErrorHelper.handleResponseError(response);
      return null;
    }
    final Debt debt = Debt.fromJson(response.data);
    _updateDebtById(id, debt);
  }

  Future<void> declineUserConnecting(String id) async {
    final url = '/debts/single/$id/connect_user/decline';
    final response = await http().post(url);
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
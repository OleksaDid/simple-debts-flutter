import 'package:dio/dio.dart';
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

  Future<void> fetchAndSetDebtList(BuildContext context) async {
    print(context.widget.toString());
    try {
      final url = '/debts';
      final response = await http().get(url);
      _debtList = DebtList.fromJson(response.data);
      notifyListeners();
    } on DioError catch(error) {
      ErrorHelper.handleDioError(error);
    }
  }

  Debt getDebt(String id) {
    return _debtList?.debts?.firstWhere(
      (debt) => debt.id == id,
      orElse: () => null
    );
  }

  Future<Debt> fetchDebt(String id) async {
    try {
      final url = '/debts/$id';
      final response = await http().get(url);
      final Debt debt = Debt.fromJson(response.data);
      _updateDebtById(id, debt);
      return debt;
    } on DioError catch(error) {
      ErrorHelper.handleDioError(error);
    }
  }

  Future<void> deleteDebt(String id) async {
    try {
      final debt = getDebt(id);
      final debtTypePath = debt.type == DebtAccountType.SINGLE_USER ? 'single' : 'multiple';
      final url = '/debts/$debtTypePath/$id';
      await http().delete(url);
      _removeDebtById(id);
    } on DioError catch(error) {
      ErrorHelper.handleDioError(error);
    }
  }

  Future<Debt> createMultipleDebt(String userId, String currency) async {
    try {
      final url = '/debts/multiple';
      final response = await http().post(url,
        data: {
          'userId': userId,
          'currency': currency
        },
      );
      final Debt debt = Debt.fromJson(response.data);
      _addDebt(debt);
      return debt;
    } on DioError catch(error) {
      ErrorHelper.handleDioError(error);
    }
  }

  Future<Debt> createSingleDebt(String userName, String currency) async {
    try {
      final url = '/debts/single';
      final response = await http().post(url,
        data: {
          'userName': userName,
          'currency': currency
        },
      );
      final Debt debt = Debt.fromJson(response.data);
      _addDebt(debt);
      return debt;
    } on DioError catch(error) {
      ErrorHelper.handleDioError(error);
    }
  }

  Future<void> acceptMultipleDebtCreation(String id) async {
    try {
      final url = '/debts/multiple/$id/creation/accept';
      final response = await http().post(url);
      final Debt debt = Debt.fromJson(response.data);
      _updateDebtById(id, debt);
    } on DioError catch(error) {
      ErrorHelper.handleDioError(error);
    }
  }

  Future<void> declineMultipleDebtCreation(String id) async {
    try {
      final url = '/debts/multiple/$id/creation/decline';
      await http().post(url);
    } on DioError catch(error) {
      ErrorHelper.handleDioError(error);
    }
  }

  Future<void> acceptAllOperations(String id) async {
    try {
      final url = '/debts/multiple/$id/accept_all_operations';
      final response = await http().post(url);
      final Debt debt = Debt.fromJson(response.data);
      _updateDebtById(id, debt);
    } on DioError catch(error) {
      ErrorHelper.handleDioError(error);
    }
  }

  Future<void> acceptUserDeletedFromDebt(String id) async {
    try {
      final url = '/debts/single/$id/i_love_lsd';
      final response = await http().post(url);
      final Debt debt = Debt.fromJson(response.data);
      _updateDebtById(id, debt);
    } on DioError catch(error) {
      ErrorHelper.handleDioError(error);
    }
  }

  Future<void> connectUserToSingleDebt(String id, String userId) async {
    try {
      final url = '/debts/single/$id/connect_user';
      final response = await http().post(url, data: {
        'userId': userId
      });
      final Debt debt = Debt.fromJson(response.data);
      _updateDebtById(id, debt);
    } on DioError catch(error) {
      ErrorHelper.handleDioError(error);
    }
  }

  Future<void> acceptUserConnecting(String id) async {
    try {
      final url = '/debts/single/$id/connect_user/accept';
      final response = await http().post(url);
      final Debt debt = Debt.fromJson(response.data);
      _updateDebtById(id, debt);
    } on DioError catch(error) {
      ErrorHelper.handleDioError(error);
    }
  }

  Future<void> declineUserConnecting(String id) async {
    try {
      final url = '/debts/single/$id/connect_user/decline';
      await http().post(url);
    } on DioError catch(error) {
      ErrorHelper.handleDioError(error);
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
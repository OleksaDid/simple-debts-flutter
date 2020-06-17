import 'package:dio/dio.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/http_auth_service_use.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/models/debts/debt_list.dart';

class DebtsService with HttpAuthServiceUse {

  Future<DebtList> fetchAndSetDebtList() async {
    try {
      final url = '/debts';
      final response = await http.get(url);
      return DebtList.fromJson(response.data);
    } on DioError catch(error) {
      throw ErrorHelper.handleDioError(error);
    }
  }

  Future<Debt> fetchDebt(String id) async {
    try {
      final url = '/debts/$id';
      final response = await http.get(url);
      return Debt.fromJson(response.data);
    } on DioError catch(error) {
      throw ErrorHelper.handleDioError(error);
    }
  }

  Future<void> deleteDebt(String id, DebtAccountType type) async {
    try {
      final url = '/debts/$id';
      await http.delete(url);
    } on DioError catch(error) {
      throw ErrorHelper.handleDioError(error);
    }
  }

  Future<Debt> createMultipleDebt(String userId, String currency) async {
    try {
      final url = '/debts/multiple';
      final response = await http.post(url,
        data: {
          'userId': userId,
          'currency': currency
        },
      );
      return Debt.fromJson(response.data);
    } on DioError catch(error) {
      throw ErrorHelper.handleDioError(error);
    }
  }

  Future<Debt> createSingleDebt(String userName, String currency) async {
    try {
      final url = '/debts/single';
      final response = await http.post(url,
        data: {
          'userName': userName,
          'currency': currency
        },
      );
      return Debt.fromJson(response.data);
    } on DioError catch(error) {
      throw ErrorHelper.handleDioError(error);
    }
  }

  Future<Debt> acceptMultipleDebtCreation(String id) async {
    try {
      final url = '/debts/multiple/$id/creation/accept';
      final response = await http.post(url);
      return Debt.fromJson(response.data);
    } on DioError catch(error) {
      throw ErrorHelper.handleDioError(error);
    }
  }

  Future<void> declineMultipleDebtCreation(String id) async {
    try {
      final url = '/debts/multiple/$id/creation/decline';
      await http.post(url);
    } on DioError catch(error) {
      throw ErrorHelper.handleDioError(error);
    }
  }

  Future<Debt> acceptAllOperations(String id) async {
    try {
      final url = '/debts/multiple/$id/accept_all_operations';
      final response = await http.post(url);
      return Debt.fromJson(response.data);
    } on DioError catch(error) {
      throw ErrorHelper.handleDioError(error);
    }
  }

  Future<Debt> acceptUserDeletedFromDebt(String id) async {
    try {
      final url = '/debts/single/$id/i_love_lsd';
      final response = await http.post(url);
      return Debt.fromJson(response.data);
    } on DioError catch(error) {
      throw ErrorHelper.handleDioError(error);
    }
  }

  Future<Debt> connectUserToSingleDebt(String id, String userId) async {
    try {
      final url = '/debts/single/$id/connect_user';
      final response = await http.post(url, data: {
        'userId': userId
      });
      return Debt.fromJson(response.data);
    } on DioError catch(error) {
      throw ErrorHelper.handleDioError(error);
    }
  }

  Future<Debt> acceptUserConnecting(String id) async {
    try {
      final url = '/debts/single/$id/connect_user/accept';
      final response = await http.post(url);
      return Debt.fromJson(response.data);
    } on DioError catch(error) {
      throw ErrorHelper.handleDioError(error);
    }
  }

  Future<void> declineUserConnecting(String id) async {
    try {
      final url = '/debts/single/$id/connect_user/decline';
      await http.post(url);
    } on DioError catch(error) {
      throw ErrorHelper.handleDioError(error);
    }
  }

}
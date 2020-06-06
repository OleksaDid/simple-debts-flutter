import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/models/debts/operation.dart';

enum SignUpMethod {
  email,
  facebook
}

const Map<SignUpMethod, String> _SIGN_UP_METHOD_ENUM_TO_STRING = {
  SignUpMethod.email: 'email',
  SignUpMethod.facebook: 'facebook',
};

enum AnalyticsEventName {
  profileUpdate,
  tokenRefresh,
  tokenRefreshFailed,
  autoLoginFailed,
  debtDelete,
  debtCreate,
  debtCreationResponse,
  acceptAllOperations,
  connectDebt,
  connectDebtResponse,
  operationCreate,
  operationCreateResponse,
  operationDelete,
}

const Map<AnalyticsEventName, String> _ANALYTICS_EVENT_NAME_TO_STRING = {
  AnalyticsEventName.profileUpdate: 'profile_update',
  AnalyticsEventName.tokenRefresh: 'token_refreshed',
  AnalyticsEventName.tokenRefreshFailed: 'token_refresh_failed',
  AnalyticsEventName.autoLoginFailed: 'auto_login_failed',
  AnalyticsEventName.debtDelete: 'debt_delete',
  AnalyticsEventName.debtCreate: 'debt_create',
  AnalyticsEventName.debtCreationResponse: 'debt_creation_response',
  AnalyticsEventName.acceptAllOperations: 'all_operations_accept',
  AnalyticsEventName.connectDebt: 'debt_connect',
  AnalyticsEventName.connectDebtResponse: 'debt_connect_response',
  AnalyticsEventName.operationCreate: 'operation_create',
  AnalyticsEventName.operationCreateResponse: 'operation_create_response',
  AnalyticsEventName.operationDelete: 'operation_delete',
};

const Map<DebtAccountType, String> _DEBT_TYPE_TO_STRING = {
  DebtAccountType.SINGLE_USER: 'single',
  DebtAccountType.MULTIPLE_USERS: 'multiple'
};

const Map<DebtStatus, String> _DEBT_STATUS_TO_STRING = {
  DebtStatus.CHANGE_AWAITING: 'change awaiting',
  DebtStatus.CONNECT_USER: 'connect user',
  DebtStatus.CREATION_AWAITING: 'creation awaiting',
  DebtStatus.UNCHANGED: 'unchanged',
  DebtStatus.USER_DELETED: 'user deleted',
};


class AnalyticsService {
  final FirebaseAnalytics analytics = FirebaseAnalytics();

  Future<void> logSignUp(SignUpMethod method) {
    return analytics.logSignUp(
      signUpMethod: _SIGN_UP_METHOD_ENUM_TO_STRING[method]
    );
  }

  Future<void> logLogin() {
    return analytics.logLogin();
  }

  Future<void> logAppOpen() {
    return analytics.logAppOpen();
  }

  Future<void> setUserId(String id) {
    return analytics.setUserId(id);
  }

  Future<void> logProfileUpdate(bool imageUpdated) {
    return _logEvent(AnalyticsEventName.profileUpdate, {
      'imageUpdated': imageUpdated
    });
  }

  Future<void> logTokenRefresh() {
    return _logEvent(AnalyticsEventName.tokenRefresh);
  }

  Future<void> logTokenRefreshError() {
    return _logEvent(AnalyticsEventName.tokenRefreshFailed);
  }

  Future<void> logAutoLoginFailed() {
    return _logEvent(AnalyticsEventName.autoLoginFailed);
  }

  Future<void> logDebtDelete(Debt debt) => _logEvent(AnalyticsEventName.debtDelete, {
      'type': _DEBT_TYPE_TO_STRING[debt.type],
      'status': _DEBT_STATUS_TO_STRING[debt.status],
      'summary': debt.summary,
      'currency': debt.currency,
      'operationsAmount': debt.moneyOperations?.length,
      'isUserMoneyAcceptor': debt.moneyReceiveStatus == MoneyReceiveStatus.YouTake
    });

  Future<void> logDebtCreate(DebtAccountType type, String currency) => _logEvent(
      AnalyticsEventName.debtCreate, {
      'type': _DEBT_TYPE_TO_STRING[type],
      'currency': currency
    });

  Future<void> logDebtCreationResponse({@required bool isAccepted}) => _logEvent(
      AnalyticsEventName.debtCreationResponse, {
      'response': isAccepted ? 'accepted' : 'declined'
    });
  
  Future<void> logAcceptAllOperations(int operationsAccepted) =>_logEvent(
      AnalyticsEventName.acceptAllOperations, {
      'operationsAccepted': operationsAccepted
    });

  Future<void> logConnectDebt(Debt debt) => _logEvent(AnalyticsEventName.connectDebt, {
      'summary': debt.summary,
      'currency': debt.currency,
      'isUserMoneyAcceptor': debt.moneyReceiveStatus == MoneyReceiveStatus.YouTake,
      'amountOfOperations': debt.moneyOperations?.length,
    });

  Future<void> logConnectDebtResponse({
    @required bool isAccepted,
    @required Debt debt
  }) => _logEvent(AnalyticsEventName.connectDebtResponse, {
      'response': isAccepted ? 'accepted': 'declined',
      'summary': debt.summary,
      'currency': debt.currency,
      'isUserMoneyAcceptor': debt.moneyReceiveStatus == MoneyReceiveStatus.YouTake,
      'amountOfOperations': debt.moneyOperations?.length,
    });

  Future<void> logOperationCreate({
    @required bool isUserMoneyReceiver,
    @required double moneyAmount,
    @required String currency,
  }) => _logEvent(AnalyticsEventName.operationCreate, {
    'isUserMoneyReceiver': isUserMoneyReceiver,
    'moneyAmount': moneyAmount,
    'currency': currency
  });

  Future<void> logOperationCreateResponse({
    @required bool isAccepted,
    @required bool isUserMoneyReceiver,
    @required Operation operation,
    @required String currency,
  }) => _logEvent(AnalyticsEventName.operationCreateResponse, {
    'response': isAccepted ? 'accepted': 'declined',
    'isUserMoneyReceiver': isUserMoneyReceiver,
    'moneyAmount': operation.moneyAmount,
    'currency': currency,
    'secondsBetweenCreationAndResponse': operation.date.difference(DateTime.now()).inSeconds,
  });

  Future<void> logOperationDelete({
    @required DateTime createDate,
    @required bool isUserMoneyReceiver,
    @required double moneyAmount,
    @required String currency,
  }) => _logEvent(AnalyticsEventName.operationDelete, {
    'secondsBetweenCreationAndDelete': createDate.difference(DateTime.now()).inSeconds,
    'isUserMoneyReceiver': isUserMoneyReceiver,
    'moneyAmount': moneyAmount,
    'currency': currency
  });



  Future<void> _logEvent(AnalyticsEventName name, [Map<String, dynamic> parameters]) {
    return analytics.logEvent(
      name: _ANALYTICS_EVENT_NAME_TO_STRING[name],
      parameters: parameters
    );
  }
}
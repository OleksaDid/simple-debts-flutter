import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simpledebts/mixins/analytics_use.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/services/debts_service.dart';
import 'package:simpledebts/services/operations_service.dart';
import 'package:simpledebts/store/debt_list.store.dart';

class DebtStore with AnalyticsUse {
  final DebtsService _debtsService = GetIt.instance<DebtsService>();
  final OperationsService _operationsService = GetIt.instance<OperationsService>();

  final DebtListStore _debtListStore = GetIt.instance<DebtListStore>();
  final BehaviorSubject<Debt> _debt;


  DebtStore(Debt debt)
      : this._debt = BehaviorSubject.seeded(debt);


  Stream<Debt> get debt$ => _debt.stream;

  Stream<void> get debtRemoved$ => _debt.where((debt) => debt == null);

  Debt get debt => _debt.value;


  void _removeDebt() {
    _debt.add(null);
  }


  Future<Debt> fetchDebt() => _debtsService
      .fetchDebt(debt.id)
      ..then((debt) => _debt.add(debt))
      ..then((debt) => _debtListStore.updateDebtById(debt.id, debt));

  Future<void> acceptMultipleDebtCreation() => _debtsService
      .acceptMultipleDebtCreation(debt.id)
      ..then((debt) => analyticsService.logDebtCreationResponse(isAccepted: true))
      ..then((debt) => _debt.add(debt))
      ..then((debt) => _debtListStore.updateDebtById(debt.id, debt));

  Future<void> declineMultipleDebtCreation() => _debtsService
      .declineMultipleDebtCreation(debt.id)
      ..then((debt) => analyticsService.logDebtCreationResponse(isAccepted: false))
      ..then((_) => _debtListStore.fetchAndSetDebtList())
      ..then((_) => _removeDebt());

  Future<void> acceptAllOperations() => _debtsService
      .acceptAllOperations(debt.id)
      ..then((_) => analyticsService.logAcceptAllOperations(debt.unacceptedOperationsAmount))
      ..then((debt) => _debt.add(debt))
      ..then((debt) => _debtListStore.updateDebtById(debt.id, debt));

  Future<void> acceptUserDeletedFromDebt() => _debtsService
      .acceptUserDeletedFromDebt(debt.id)
      ..then((debt) => _debt.add(debt))
      ..then((debt) => _debtListStore.updateDebtById(debt.id, debt));

  Future<void> connectUserToSingleDebt(String userId) => _debtsService
      .connectUserToSingleDebt(debt.id, userId)
      ..then((_) => analyticsService.logConnectDebt(debt))
      ..then((debt) => _debt.add(debt))
      ..then((debt) => _debtListStore.updateDebtById(debt.id, debt));

  Future<void> acceptUserConnecting() => _debtsService
      .acceptUserConnecting(debt.id)
      ..then((_) => analyticsService.logConnectDebtResponse(
          isAccepted: true,
          debt: debt
      ))
      ..then((debt) => _debt.add(debt))
      ..then((debt) => _debtListStore.updateDebtById(debt.id, debt));

  Future<void> declineUserConnecting() => _debtsService
      .declineUserConnecting(debt.id)
      ..then((_) => analyticsService.logConnectDebtResponse(
          isAccepted: false,
          debt: debt
      ))
      ..then((_) {
        if(debt.isUserStatusAcceptor) {
          return _debtListStore
              .fetchAndSetDebtList()
              ..then((_) => _removeDebt());
        } else {
          return fetchDebt();
        }
      });

  Future<void> addOperation({
    @required String description,
    @required String moneyReceiver,
    @required double moneyAmount
  }) => _operationsService
      .createOperation(
          id: debt.id,
          description: description,
          moneyReceiver: moneyReceiver,
          moneyAmount: moneyAmount
      )
      ..then((_) => analyticsService.logOperationCreate(
          isUserMoneyReceiver: moneyReceiver != debt.user.id,
          moneyAmount: moneyAmount,
          currency: debt.currency
      ))
      .then((_) => fetchDebt());

  Future<void> acceptOperation(String id) => _operationsService
      .acceptOperation(id)
      ..then((_) => analyticsService.logOperationCreateResponse(
          isAccepted: true,
          isUserMoneyReceiver: debt.getOperation(id).moneyReceiver != debt.user.id,
          operation: debt.getOperation(id),
          currency: debt.currency
      ))
      .then((_) => fetchDebt());

  Future<void> declineOperation(String id) => _operationsService
      .declineOperation(id)
      ..then((_) => analyticsService.logOperationCreateResponse(
          isAccepted: false,
          isUserMoneyReceiver: debt.getOperation(id).moneyReceiver != debt.user.id,
          operation: debt.getOperation(id),
          currency: debt.currency
      ))
      .then((_) => fetchDebt());

  Future<void> deleteOperation(String id) => _operationsService
      .deleteOperation(id)
      ..then((_) => analyticsService.logOperationDelete(
          isUserMoneyReceiver: debt.getOperation(id).moneyReceiver != debt.user.id,
          currency: debt.currency,
          createDate: debt.getOperation(id).date,
          moneyAmount: debt.getOperation(id).moneyAmount
      ))
      .then((_) => fetchDebt());
}
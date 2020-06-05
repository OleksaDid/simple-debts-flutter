import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/services/debts_service.dart';
import 'package:simpledebts/store/debt_list.store.dart';

class DebtStore {
  final DebtsService _debtsService = GetIt.instance<DebtsService>();
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
      ..then((debt) => _debt.add(debt))
      ..then((debt) => _debtListStore.updateDebtById(debt.id, debt));

  Future<void> declineMultipleDebtCreation() => _debtsService
      .declineMultipleDebtCreation(debt.id)
      ..then((_) => _debtListStore.fetchAndSetDebtList())
      ..then((_) => _removeDebt());

  Future<void> acceptAllOperations() => _debtsService
      .acceptAllOperations(debt.id)
      ..then((debt) => _debt.add(debt))
      ..then((debt) => _debtListStore.updateDebtById(debt.id, debt));

  Future<void> acceptUserDeletedFromDebt() => _debtsService
      .acceptUserDeletedFromDebt(debt.id)
      ..then((debt) => _debt.add(debt))
      ..then((debt) => _debtListStore.updateDebtById(debt.id, debt));

  Future<void> connectUserToSingleDebt(String userId) => _debtsService
      .connectUserToSingleDebt(debt.id, userId)
      ..then((debt) => _debt.add(debt))
      ..then((debt) => _debtListStore.updateDebtById(debt.id, debt));

  Future<void> acceptUserConnecting() => _debtsService
      .acceptUserConnecting(debt.id)
      ..then((debt) => _debt.add(debt))
      ..then((debt) => _debtListStore.updateDebtById(debt.id, debt));

  Future<void> declineUserConnecting() => _debtsService
      .declineUserConnecting(debt.id)
      ..then((_) {
        if(debt.statusAcceptor != debt.user.id) {
          return _debtListStore
              .fetchAndSetDebtList()
              ..then((_) => _removeDebt());
        } else {
          return fetchDebt();
        }
      });
}
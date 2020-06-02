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


  Future<Debt> fetchDebt(String id) => _debtsService
      .fetchDebt(id)
      ..then((debt) => _debt.add(debt))
      ..then((debt) => _debtListStore.updateDebtById(id, debt));

  Future<void> acceptMultipleDebtCreation(String id) => _debtsService
      .acceptMultipleDebtCreation(id)
      ..then((debt) => _debt.add(debt))
      ..then((debt) => _debtListStore.updateDebtById(id, debt));

  Future<void> declineMultipleDebtCreation(String id) => _debtsService
      .declineMultipleDebtCreation(id)
      ..then((_) => _debtListStore.fetchAndSetDebtList())
      ..then((_) => _removeDebt());

  Future<void> acceptAllOperations(String id) => _debtsService
      .acceptAllOperations(id)
      ..then((debt) => _debt.add(debt))
      ..then((debt) => _debtListStore.updateDebtById(id, debt));

  Future<void> acceptUserDeletedFromDebt(String id) => _debtsService
      .acceptUserDeletedFromDebt(id)
      ..then((debt) => _debt.add(debt))
      ..then((debt) => _debtListStore.updateDebtById(id, debt));

  Future<void> connectUserToSingleDebt(String id, String userId) => _debtsService
      .connectUserToSingleDebt(id, userId)
      ..then((debt) => _debt.add(debt))
      ..then((debt) => _debtListStore.updateDebtById(id, debt));

  Future<void> acceptUserConnecting(String id) => _debtsService
      .acceptUserConnecting(id)
      ..then((debt) => _debt.add(debt))
      ..then((debt) => _debtListStore.updateDebtById(id, debt));

  Future<void> declineUserConnecting(String id) => _debtsService
      .declineUserConnecting(id)
      ..then((_) {
        if(debt.statusAcceptor != debt.user.id) {
          return _debtListStore
              .fetchAndSetDebtList()
              ..then((_) => _removeDebt());
        } else {
          return fetchDebt(debt.id);
        }
      });
}
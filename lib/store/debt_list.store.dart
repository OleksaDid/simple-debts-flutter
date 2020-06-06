import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simpledebts/mixins/analytics_use.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/models/debts/debt_list.dart';
import 'package:simpledebts/models/debts/debt_list_summary.dart';
import 'package:simpledebts/services/debts_service.dart';

class DebtListStore with AnalyticsUse {
  final DebtsService _debtsService = GetIt.instance<DebtsService>();
  final BehaviorSubject<DebtList> _debtList = BehaviorSubject();

  Stream<DebtList> get _stream$ => _debtList.stream;
  DebtList get _currentDebtList => _debtList.value;


  Stream<List<Debt>> get debts$ => _stream$.map((debtList) => debtList.debts);
  
  Stream<DebtListSummary> get summary$ => _stream$.map((debtList) => debtList.summary);

  Debt getDebt(String id) => _currentDebtList.debts.firstWhere(
      (debt) => debt.id == id,
      orElse: () => null
  );

  void updateDebtById(String id, Debt debt) {
    final current = _currentDebtList;
    final debtIndex = current.debts.indexWhere((debt) => debt.id == id);
    current.debts[debtIndex] = debt;
    _debtList.add(current);
  }

  
  Future<void> fetchAndSetDebtList() => _debtsService
      .fetchAndSetDebtList()
      ..then((list) => _debtList.add(list));

  Future<void> deleteDebt(String id) =>  _debtsService
      .deleteDebt(id, getDebt(id).type)
      ..then((_) => analyticsService.logDebtDelete(getDebt(id)))
      ..then((_) => _removeDebtById(id));

  Future<Debt> createMultipleDebt(String userId, String currency) => _debtsService
      .createMultipleDebt(userId, currency)
      ..then((debt) => _addDebt(debt))
      ..then((_) => analyticsService.logDebtCreate(DebtAccountType.MULTIPLE_USERS, currency));

  Future<Debt> createSingleDebt(String userName, String currency) => _debtsService
      .createSingleDebt(userName, currency)
      ..then((debt) => _addDebt(debt))
      ..then((_) => analyticsService.logDebtCreate(DebtAccountType.SINGLE_USER, currency));


  void _addDebt(Debt debt) {
    final current = _currentDebtList;
    current.debts.insert(0, debt);
    _debtList.add(current);
  }

  void _removeDebtById(String id) {
    final current = _currentDebtList;
    final debtIndex = current.debts.indexWhere((debt) => debt.id == id);
    current.debts.removeAt(debtIndex);
    _debtList.add(current);
  }

}
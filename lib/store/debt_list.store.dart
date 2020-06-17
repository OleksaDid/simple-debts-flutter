import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simpledebts/services/shared_preferences_service.dart';
import 'package:simpledebts/mixins/analytics_use.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/models/debts/debt_list.dart';
import 'package:simpledebts/services/debts_service.dart';

class DebtListStore with AnalyticsUse {
  final DebtsService _debtsService = GetIt.instance<DebtsService>();
  final SharedPreferencesService _sharedPreferencesService = GetIt.instance<SharedPreferencesService>();
  final BehaviorSubject<DebtList> _debtList = BehaviorSubject();

  Stream<DebtList> get _stream$ => _debtList.stream;
  DebtList get _currentDebtList => _debtList.value;


  Stream<List<Debt>> get debts$ => _stream$.map((debtList) => debtList?.debts);
  List<Debt> get debts => _currentDebtList?.debts;

  Debt getDebt(String id) => _currentDebtList.debts.firstWhere(
      (debt) => debt.id == id,
      orElse: () => null
  );

  void updateDebtById(String id, Debt debt) {
    final current = _currentDebtList;
    final debtIndex = current.debts.indexWhere((debt) => debt.id == id);
    current.debts[debtIndex] = debt;
    _updateDebtList(current);
  }

  void resetStore() => _debtList.add(null);


  Future<DebtList> getCachedList() => _sharedPreferencesService
      .getDebtList()
      ..then((list) {
        if(list != null) _updateDebtList(list);
      });
  
  Future<void> fetchAndSetDebtList() => _debtsService
      .fetchAndSetDebtList()
      ..then(_updateDebtList);

  Future<void> deleteDebt(String id) =>  _debtsService
      .deleteDebt(id)
      ..then((_) => analyticsService.logDebtDelete(getDebt(id)))
      ..then((_) => _removeDebtById(id));

  Future<Debt> createMultipleDebt(String userId, String currency) => _debtsService
      .createMultipleDebt(userId, currency)
      ..then(_addDebt)
      ..then((_) => analyticsService.logDebtCreate(DebtAccountType.MULTIPLE_USERS, currency));

  Future<Debt> createSingleDebt(String userName, String currency) => _debtsService
      .createSingleDebt(userName, currency)
      ..then(_addDebt)
      ..then((_) => analyticsService.logDebtCreate(DebtAccountType.SINGLE_USER, currency));


  void _addDebt(Debt debt) {
    final current = _currentDebtList;
    current.debts.insert(0, debt);
    _updateDebtList(current);
  }

  void _removeDebtById(String id) {
    final current = _currentDebtList;
    final debtIndex = current.debts.indexWhere((debt) => debt.id == id);
    current.debts.removeAt(debtIndex);
    _updateDebtList(current);
  }

  void _updateDebtList(DebtList debtList) {
    _sharedPreferencesService.saveDebtList(debtList);
    _debtList.add(debtList);
  }

}
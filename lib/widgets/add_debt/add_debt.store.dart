import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/models/common/errors/failure.dart';
import 'package:simpledebts/models/common/route/id_route_argument.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/screens/debt_screen.dart';
import 'package:simpledebts/store/debt_list.store.dart';

enum FormStep {
  Initial,
  UsersSearch,
  Confirmation,
  Creation
}

class AddDebtStore {
  final DebtListStore _debtListStore = GetIt.instance<DebtListStore>();
  final BehaviorSubject<FormStep> _formStep = BehaviorSubject.seeded(FormStep.Initial);
  final BehaviorSubject<String> _currency = BehaviorSubject.seeded('UAH');
  String _virtualUserName = '';
  User _selectedUser;

  Stream<FormStep> get currentStep$ => _formStep.stream;

  FormStep get currentStep => _formStep.value;
  String get virtualUserName => _virtualUserName;
  User get selectedUser => _selectedUser;
  String get currency => _currency.value;


  void setUsersSearchStep() => _formStep.add(FormStep.UsersSearch);

  void setInitialStep() {
    _virtualUserName = '';
    _selectedUser = null;
    _formStep.add(FormStep.Initial);
  }

  void setRegisteredUser(BuildContext context, User user) {
    FocusScope.of(context).unfocus();
    _selectedUser = user;
    _formStep.add(FormStep.Confirmation);
  }

  void setVirtualUserName(BuildContext context, String name) {
    FocusScope.of(context).unfocus();
    _virtualUserName = name;
    _formStep.add(FormStep.Confirmation);
  }

  void cancelConfirmation() => _virtualUserName != null
      ? setInitialStep()
      : setUsersSearchStep();

  void setCreationStep() => _formStep.add(FormStep.Creation);

  void setCurrency(String currency) => _currency.add(currency);


  Future<void> createDebt(BuildContext context) async {
    setCreationStep();
    try {
      Debt debt;
      if(_virtualUserName != null && _virtualUserName.isNotEmpty) {
        debt = await _debtListStore.createSingleDebt(_virtualUserName, currency);
      } else {
        debt = await _debtListStore.createMultipleDebt(_selectedUser.id, currency);
      }
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(DebtScreen.routeName, arguments: IdRouteArgument(debt.id));
    } on Failure catch(error) {
      ErrorHelper.showErrorDialog(context, error.message);
      setInitialStep();
    }
  }

}
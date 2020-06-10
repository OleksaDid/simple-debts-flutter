import 'package:flutter/cupertino.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/spinner_store_use.dart';
import 'package:simpledebts/models/common/errors/failure.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/store/debt.store.dart';

class ConnectUserStore with SpinnerStoreUse {
  final BehaviorSubject<User> _selectedUser = BehaviorSubject.seeded(null);

  Stream<User> get selectedUser$ => _selectedUser.stream;

  Future<void> connectUser(BuildContext context) async {
    showSpinner();
    try {
      await GetIt.instance<DebtStore>().connectUserToSingleDebt(_selectedUser.value.id);
      Navigator.of(context).pop();
    } on Failure catch(error) {
      ErrorHelper.showErrorDialog(context, error.message);
    }
    hideSpinner();
  }

  void selectUser(User user) {
    _selectedUser.add(user);
  }

  void resetUser() {
    _selectedUser.add(null);
  }
}
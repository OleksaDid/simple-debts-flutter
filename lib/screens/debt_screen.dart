import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/helpers/dialog_helper.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/screen_widget.dart';
import 'package:simpledebts/mixins/spinner_modal.dart';
import 'package:simpledebts/models/common/errors/failure.dart';
import 'package:simpledebts/models/common/route/id_route_argument.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/screens/base_screen_state.dart';
import 'package:simpledebts/store/debt.store.dart';
import 'package:simpledebts/store/debt_list.store.dart';
import 'package:simpledebts/widgets/debt/connect_user_dialog.dart';
import 'package:simpledebts/widgets/debt/debt_screen_body.dart';

enum DropdownActions {
  deleteDebt,
  connectUser,
}

class DebtScreen extends StatefulWidget with ScreenWidget<IdRouteArgument>, SpinnerModal {

  static const String routeName = '/debt_screen';

  @override
  _DebtScreenState createState() => _DebtScreenState();
}

class _DebtScreenState extends BaseScreenState<DebtScreen> {
  final DebtListStore _debtListStore = GetIt.instance<DebtListStore>();
  DebtStore _debtStore;
  Stream<Debt> _debt$;

  Debt get debt => _debtStore.debt;

  Future<void> _onPopupMenuSelect(BuildContext context, DropdownActions action) async {
    switch(action) {
      case DropdownActions.deleteDebt: {
        _deleteDebt();
        break;
      }

      case DropdownActions.connectUser: {
        _connectUser();
        break;
      }
    }
  }

  Future<void> _deleteDebt() async {
    final bool deleteDebt = await DialogHelper.showDeleteDialog(context, 'Delete this debt?');
    if(deleteDebt) {
      widget.showSpinnerModal(context);
      try {
        await _debtListStore.deleteDebt(debt.id);
        Navigator.of(context).pop();
      } on Failure catch(error) {
        ErrorHelper.showErrorSnackBar(context, error.message);
      }
      widget.hideSpinnerModal(context);
    }
  }

  Future<void> _acceptAllOperations() async {
    widget.showSpinnerModal(context);
    try {
      await _debtStore.acceptAllOperations();
    } on Failure catch(error) {
      ErrorHelper.showErrorSnackBar(context, error.message);
    }
    widget.hideSpinnerModal(context);
  }

  void _connectUser() {
    showDialog(
      context: context,
      builder: (context) => ConnectUserDialog()
    );
  }

  Stream<Debt> _getDebt$(BuildContext context) {
    final debtId = widget.getRouteArguments(context).id;
    final debt = _debtListStore.getDebt(debtId);
    _setupDebtStore(debt);
    return _debtStore.debt$;
  }

  Color _getHeaderColor(Debt debt) {
    return debt?.moneyReceiveStatus != MoneyReceiveStatus.YouTake
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;
  }

  void _setupDebtStore(Debt debt) {
    final getIt = GetIt.instance;
    if(getIt.isRegistered<DebtStore>()) {
      getIt.unregister<DebtStore>();
    }
    getIt.registerSingleton<DebtStore>(DebtStore(debt));
    _subscribeOnDebtDelete();
    _debtStore = getIt<DebtStore>();
  }

  void _subscribeOnDebtDelete() {
    addSubscription(GetIt.instance<DebtStore>()
        .debtRemoved$
        .listen((_) => Navigator.of(context).pop()));
  }

  @override
  Widget build(BuildContext context) {
    // run _getDebt$ only once during lifecycle
    if(_debt$ == null) {
      _debt$ = _getDebt$(context);
    }

    return StreamBuilder(
      stream: _debt$,
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final Debt debt = snapshot.data;
          return Scaffold(
              appBar: AppBar(
                  actions: [
                    if(debt.hasUnacceptedOperations) FlatButton(
                      child: Text('ACCEPT ALL'),
                      textColor: Colors.white,
                      onPressed: _acceptAllOperations,
                    ),
                    PopupMenuButton(
                      icon: Icon(Icons.more_vert),
                      itemBuilder: (_) => [
                        PopupMenuItem(
                          child: Text('Delete debt'),
                          value: DropdownActions.deleteDebt,
                        ),
                        if(debt.isUserConnectAllowed) PopupMenuItem(
                          child: Text('Connect registered user'),
                          value: DropdownActions.connectUser,
                        ),
                      ],
                      onSelected: (value) => _onPopupMenuSelect(context, value),
                    )
                  ],
                  elevation: 0,
                  backgroundColor: _getHeaderColor(debt)
              ),
              body: Visibility(
                visible: debt != null,
                child: DebtScreenBody(
                  debt: debt,
                ),
              )
          );
        }
      },
    );
  }
}
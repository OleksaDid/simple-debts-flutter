import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/helpers/dialog_helper.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/screen_widget.dart';
import 'package:simpledebts/mixins/spinner_modal.dart';
import 'package:simpledebts/models/common/route/id_route_argument.dart';
import 'package:simpledebts/models/debts/debt.dart';
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

class _DebtScreenState extends State<DebtScreen> {
  final DebtListStore _debtListStore = GetIt.instance<DebtListStore>();

  StreamSubscription _debtRemovalSubscription;

  @override
  dispose() {
    _unsubscribeFromDebtDelete();
    super.dispose();
  }

  Future<void> _onPopupMenuSelect(BuildContext context, DropdownActions action, String debtId) async {
    switch(action) {
      case DropdownActions.deleteDebt: {
        _deleteDebt(debtId);
        break;
      }

      case DropdownActions.connectUser: {
        _connectUser(debtId);
        break;
      }
    }
  }

  Future<void> _deleteDebt(String debtId) async {
    final bool deleteDebt = await DialogHelper.showDeleteDialog(context, 'Delete this debt?');
    if(deleteDebt) {
      widget.showSpinnerModal(context);
      try {
        await _debtListStore.deleteDebt(debtId);
        Navigator.of(context).pop();
      } catch(error) {
        ErrorHelper.showErrorSnackBar(context);
      }
      widget.hideSpinnerModal(context);
    }
  }

  void _connectUser(String debtId) {
    showDialog(
      context: context,
      builder: (context) => ConnectUserDialog(debtId: debtId,)
    );
  }

  Stream<Debt> _getDebt$(BuildContext context) {
    final debtId = widget.getRouteArguments(context).id;
    final debt = _debtListStore.getDebt(debtId);
    final debtStore = _setupDebtStore(debt);
    return debtStore.debt$;
  }

  Color _getHeaderColor(Debt debt) {
    return debt?.moneyReceiveStatus != MoneyReceiveStatus.YouTake
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;
  }

  DebtStore _setupDebtStore(Debt debt) {
    final getIt = GetIt.instance;
    if(getIt.isRegistered<DebtStore>()) {
      getIt.unregister<DebtStore>();
    }
    getIt.registerSingleton<DebtStore>(DebtStore(debt));
    _subscribeOnDebtDelete();
    return getIt<DebtStore>();
  }

  void _subscribeOnDebtDelete() {
    _debtRemovalSubscription = GetIt.instance<DebtStore>()
        .debtRemoved$
        .listen((_) => Navigator.of(context).pop());
  }

  void _unsubscribeFromDebtDelete() {
    if(_debtRemovalSubscription != null) {
      _debtRemovalSubscription.cancel();
    }
  }

  @override
  Widget build(BuildContext context) {

    return StreamBuilder(
      stream: _getDebt$(context),
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
                      onSelected: (value) => _onPopupMenuSelect(context, value, debt.id),
                    )
                  ],
                  elevation: 0,
                  backgroundColor: _getHeaderColor(debt)
              ),
              body: DebtScreenBody(
                debt: debt,
              )
          );
        }
      },
    );
  }
}
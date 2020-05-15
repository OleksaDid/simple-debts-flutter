import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/helpers/dialog_helper.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/screen_widget.dart';
import 'package:simpledebts/mixins/spinner_modal.dart';
import 'package:simpledebts/models/common/id_route_argument.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/providers/debts_provider.dart';
import 'package:simpledebts/widgets/debt/debt_screen_body.dart';

enum DropdownActions {
  deleteDebt,
  connectUser,
}

class DebtScreen extends StatelessWidget with ScreenWidget<IdRouteArgument>, SpinnerModal {

  static const String routeName = '/debt_screen';
  
  Future<void> _onPopupMenuSelect(BuildContext context, DropdownActions action, String debtId) async {
    switch(action) {
      case DropdownActions.deleteDebt: {
        _deleteDebt(context, debtId);
        break;
      }

      case DropdownActions.connectUser: {
        // TODO: implement connect user
        break;
      }
    }
  }

  // TODO: throws error
  Future<void> _deleteDebt(BuildContext context, String debtId) async {
    final debtProvider = Provider.of<DebtsProvider>(context, listen: false);
    final bool deleteDebt = await DialogHelper.showDeleteDialog(context, 'Delete this debt?');
    if(deleteDebt) {
      showSpinnerModal(context);
      try {
        await debtProvider.deleteDebt(debtId);
        Navigator.of(context).pop();
      } catch(error) {
        ErrorHelper.showErrorSnackBar(context);
      }
      hideSpinnerModal(context);
    }
  }

  Debt _getDebt(BuildContext context) {
    final debtId = getRouteArguments(context).id;
    return Provider.of<DebtsProvider>(context).getDebt(debtId);
  }

  Color _getHeaderColor(BuildContext context, Debt debt) {
    return debt?.moneyReceiveStatus != MoneyReceiveStatus.YouTake
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;
  }

  @override
  Widget build(BuildContext context) {
    final debt = _getDebt(context);

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
                  if(debt.type == DebtAccountType.SINGLE_USER) PopupMenuItem(
                    child: Text('Connect registered user'),
                    value: DropdownActions.connectUser,
                  ),
                ],
                onSelected: (value) => _onPopupMenuSelect(context, value, debt.id),
              )
            ],
            elevation: 0,
            backgroundColor: _getHeaderColor(context, debt)
        ),
        body: DebtScreenBody(
          debt: debt,
        )
    );
  }
}
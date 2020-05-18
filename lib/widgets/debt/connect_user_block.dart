import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/spinner_modal.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/providers/debts_provider.dart';
import 'package:simpledebts/widgets/debt/bottom_buttons_row.dart';
import 'package:simpledebts/widgets/debt/debt_screen_bottom_button.dart';
import 'package:simpledebts/widgets/debt/operations_list_widget.dart';

class ConnectUserBlock extends StatelessWidget with SpinnerModal {
  final Debt debt;

  ConnectUserBlock({
    @required this.debt
  });

  String _getInfoBlockText() {
    return debt.statusAcceptor != debt.user.id
        ? '${debt.user.name} has invited you to join this record'
        : 'You have requiested ${debt.user.name} to join this record';
  }

  Future<void> _cancelConnectionRequest(BuildContext context) async {
    showSpinnerModal(context);
    try {
      final debts = Provider.of<DebtsProvider>(context, listen: false);
      await debts.declineUserConnecting(debt.id);
      if(debt.statusAcceptor != debt.user.id) {
        await debts.fetchAndSetDebtList();
        Navigator.of(context).pop();
      } else {
        await debts.fetchDebt(debt.id);
      }
    } catch(error) {
      ErrorHelper.handleError(error);
    }
    hideSpinnerModal(context);
  }

  Future<void> _acceptConnectionRequest(BuildContext context) async {
    showSpinnerModal(context);
    try {
      final debts = Provider.of<DebtsProvider>(context, listen: false);
      await debts.acceptUserConnecting(debt.id);
      hideSpinnerModal(context);
      await debts.fetchDebt(debt.id);
    } catch(error) {
      ErrorHelper.handleError(error);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                _getInfoBlockText(),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        Divider(thickness: 2,),
        Expanded(
          child: OperationsListWidget(
            operations: debt.moneyOperations,
            debt: debt,
            showBottomButtons: false,
          ),
        ),
        if(debt.statusAcceptor == debt.user.id) Container(
          width: double.infinity,
          child: DebtScreenBottomButton(
            title: 'CANCEL REQUEST',
            color: Theme.of(context).colorScheme.secondary,
            onTap: () => _cancelConnectionRequest(context),
          ),
        ),
        if(debt.statusAcceptor != debt.user.id) BottomButtonsRow(
          secondaryButton: DebtScreenBottomButton(
            title: 'DECLINE',
            color: Theme.of(context).colorScheme.secondary,
            onTap: () => _cancelConnectionRequest(context),
          ),
          primaryButton: DebtScreenBottomButton(
            title: 'ACCEPT',
            color: Theme.of(context).colorScheme.primary,
            onTap: () => _acceptConnectionRequest(context),
          ),
        )
      ],
    );
  }

}
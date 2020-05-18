import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/spinner_modal.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/providers/debts_provider.dart';
import 'package:simpledebts/widgets/common/empty_list_placeholder.dart';
import 'package:simpledebts/widgets/debt/bottom_buttons_row.dart';
import 'package:simpledebts/widgets/debt/debt_screen_bottom_button.dart';

class DebtCreationAccept extends StatelessWidget with SpinnerModal {
  final Debt debt;

  DebtCreationAccept({
    @required this.debt
  });

  Future<void> _acceptCreation(BuildContext context) async {
    showSpinnerModal(context);
    try {
      final debts = Provider.of<DebtsProvider>(context, listen: false);
      await debts.acceptMultipleDebtCreation(debt.id);
      hideSpinnerModal(context);
      await debts.fetchDebt(debt.id);
    } catch(error) {
      hideSpinnerModal(context);
      ErrorHelper.showErrorSnackBar(context);
    }
  }

  Future<void> _declineCreation(BuildContext context) async {
    showSpinnerModal(context);
    try {
      final debts = Provider.of<DebtsProvider>(context, listen: false);
      await debts.declineMultipleDebtCreation(debt.id);
      hideSpinnerModal(context);
      debts.fetchAndSetDebtList(context);
      Navigator.pop(context);
    } catch(error) {
      hideSpinnerModal(context);
      ErrorHelper.showErrorSnackBar(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
          child: EmptyListPlaceholder(
            icon: Icons.add,
            title: 'New debt',
            subtitle: debt.statusAcceptor == debt.user.id
                ? 'You have invited ${debt.user.name} to create debt \n Waiting for response'
                : '${debt.user.name} invites you to create debt',
          ),
        ),
        if(debt.statusAcceptor != debt.user.id) BottomButtonsRow(
          primaryButton: DebtScreenBottomButton(
            title: 'ACCEPT',
            color: Theme.of(context).colorScheme.primary,
            onTap: () => _acceptCreation(context),
          ),
          secondaryButton: DebtScreenBottomButton(
            title: 'DECLINE',
            color: Theme.of(context).colorScheme.secondary,
            onTap: () => _declineCreation(context),
          ),
        ),
        if(debt.statusAcceptor == debt.user.id) Container(
          width: double.infinity,
          child: DebtScreenBottomButton(
            title: 'CANCEL',
            color: Theme.of(context).colorScheme.secondary,
            onTap: () => _declineCreation(context),
          ),
        )
      ],
    );
  }

}
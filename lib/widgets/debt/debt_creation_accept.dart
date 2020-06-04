import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/spinner_modal.dart';
import 'package:simpledebts/models/common/errors/failure.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/store/debt.store.dart';
import 'package:simpledebts/widgets/common/empty_list_placeholder.dart';
import 'package:simpledebts/widgets/debt/bottom_buttons_row.dart';
import 'package:simpledebts/widgets/debt/debt_screen_bottom_button.dart';

class DebtCreationAccept extends StatelessWidget with SpinnerModal {
  final DebtStore _debtStore = GetIt.instance<DebtStore>();
  final Debt debt;

  DebtCreationAccept({
    @required this.debt
  });

  Future<void> _acceptCreation(BuildContext context) async {
    showSpinnerModal(context);
    try {
      await _debtStore.acceptMultipleDebtCreation(debt.id);
      hideSpinnerModal(context);
    } on Failure catch(error) {
      hideSpinnerModal(context);
      ErrorHelper.showErrorSnackBar(context, error.message);
    }
  }

  Future<void> _declineCreation(BuildContext context) async {
    showSpinnerModal(context);
    try {
      await _debtStore.declineMultipleDebtCreation(debt.id);
      hideSpinnerModal(context);
    } on Failure catch(error) {
      hideSpinnerModal(context);
      ErrorHelper.showErrorSnackBar(context, error.message);
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
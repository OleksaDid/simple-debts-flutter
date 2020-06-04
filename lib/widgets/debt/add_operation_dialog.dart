import 'package:flutter/material.dart';
import 'package:simpledebts/helpers/dialog_helper.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/widgets/debt/add_operation_form_widget.dart';

class AddOperationDialog extends StatelessWidget {
  final Debt debt;
  final String moneyReceiver;
  final Future<void> Function() onOperationAdded;

  AddOperationDialog({
    @required this.debt,
    @required this.moneyReceiver,
    @required this.onOperationAdded,
  });

  @override
  Widget build(BuildContext context) {
    return DialogHelper.getThemedDialog(
      child: AddOperationFormWidget(
        debt: debt,
        moneyReceiver: moneyReceiver,
        onOperationAdded: onOperationAdded,
      ),
    );
  }


}
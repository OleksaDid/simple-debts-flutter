import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/spinner_store_use.dart';
import 'package:simpledebts/providers/debts_provider.dart';
import 'package:simpledebts/providers/operations_provider.dart';
import 'package:simpledebts/widgets/common/button_spinner.dart';

class OperationConfirmationButtons extends StatelessWidget with SpinnerStoreUse {
  final String operationId;
  final String debtId;
  final MainAxisSize rowSize;

  OperationConfirmationButtons({
    @required this.operationId,
    @required this.debtId,
    this.rowSize = MainAxisSize.min,
  });

  Future<void> _acceptOperation(BuildContext context) async {
    showSpinner();
    try {
      await Provider.of<OperationsProvider>(context, listen: false).acceptOperation(operationId);
      await Provider.of<DebtsProvider>(context, listen: false).fetchDebt(debtId);
    } catch(error) {
      ErrorHelper.handleError(error);
    }
    hideSpinner();
  }

  Future<void> _declineOperation(BuildContext context) async {
    showSpinner();
    try {
      await Provider.of<OperationsProvider>(context, listen: false).declineOperation(operationId);
      await Provider.of<DebtsProvider>(context, listen: false).fetchDebt(debtId);
    } catch(error) {
      ErrorHelper.handleError(error);
    }
    hideSpinner();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: rowSize,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if(!spinnerVisible) FlatButton(
          child: Text('DECLINE'),
          onPressed: () => _declineOperation(context),
          textColor: Theme.of(context).accentColor,
        ),
        if(!spinnerVisible) FlatButton(
          child: Text('ACCEPT'),
          onPressed: () => _acceptOperation(context),
          textColor: Theme.of(context).accentColor,
        ),
        if(spinnerVisible) ButtonSpinner(radius: 20,)
      ],
    );
  }
}
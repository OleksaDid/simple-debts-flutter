import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/spinner_store_use.dart';
import 'package:simpledebts/models/common/errors/failure.dart';
import 'package:simpledebts/services/operations_service.dart';
import 'package:simpledebts/store/debt.store.dart';
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
      await GetIt.instance<OperationsService>().acceptOperation(operationId);
      await GetIt.instance<DebtStore>().fetchDebt(debtId);
    } on Failure catch(error) {
      ErrorHelper.showErrorDialog(context, error.message);
    }
    hideSpinner();
  }

  Future<void> _declineOperation(BuildContext context) async {
    showSpinner();
    try {
      await GetIt.instance<OperationsService>().declineOperation(operationId);
      await GetIt.instance<DebtStore>().fetchDebt(debtId);
    } on Failure catch(error) {
      ErrorHelper.showErrorDialog(context, error.message);
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
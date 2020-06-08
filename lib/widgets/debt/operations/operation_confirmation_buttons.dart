import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/spinner_store_use.dart';
import 'package:simpledebts/models/common/errors/failure.dart';
import 'package:simpledebts/store/debt.store.dart';
import 'package:simpledebts/widgets/common/button_spinner.dart';

class OperationConfirmationButtons extends StatelessWidget with SpinnerStoreUse {
  final String operationId;
  final MainAxisSize rowSize;
  final void Function(BuildContext context) onConfirm;

  OperationConfirmationButtons({
    @required this.operationId,
    this.rowSize = MainAxisSize.min,
    this.onConfirm
  });

  Future<void> _acceptOperation(BuildContext context) async {
    showSpinner();
    try {
      await GetIt.instance<DebtStore>().acceptOperation(operationId);
      if(onConfirm != null) {
        onConfirm(context);
      }
    } on Failure catch(error) {
      hideSpinner();
      ErrorHelper.showErrorDialog(context, error.message);
    }
  }

  Future<void> _declineOperation(BuildContext context) async {
    showSpinner();
    try {
      await GetIt.instance<DebtStore>().declineOperation(operationId);
      if(onConfirm != null) {
        onConfirm(context);
      }
    } on Failure catch(error) {
      hideSpinner();
      ErrorHelper.showErrorDialog(context, error.message);
    }
  }

  @override
  Widget build(BuildContext context) {
    return
      spinnerContainer(
        spinner: Container(
          width: 40,
          height: 48,
          alignment: Alignment.centerRight,
          child: ButtonSpinner(radius: 20,)
        ),
        replacement: Row(
          mainAxisSize: rowSize,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            FlatButton(
              child: Text('DECLINE'),
              onPressed: () => _declineOperation(context),
              textColor: Theme.of(context).accentColor,
            ),
            FlatButton(
              child: Text('ACCEPT'),
              onPressed: () => _acceptOperation(context),
              textColor: Theme.of(context).accentColor,
            ),
          ],
        ),
      );
  }
}
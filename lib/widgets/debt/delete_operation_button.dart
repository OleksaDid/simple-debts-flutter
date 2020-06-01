import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/helpers/dialog_helper.dart';
import 'package:simpledebts/mixins/spinner_store_use.dart';
import 'package:simpledebts/providers/debts_provider.dart';
import 'package:simpledebts/providers/operations_provider.dart';
import 'package:simpledebts/widgets/common/button_spinner.dart';

class DeleteOperationButton extends StatelessWidget with SpinnerStoreUse {
  final String operationId;
  final String debtId;

  DeleteOperationButton({
    @required this.operationId,
    @required this.debtId
  });

  Future<void> _deleteOperation(BuildContext context) async {
    final deleteOperation = await DialogHelper.showDeleteDialog(context, 'Delete this operation?');
    if(deleteOperation == true) {
      showSpinner();
      try {
        await Provider.of<OperationsProvider>(context, listen: false).deleteOperation(operationId);
        await Provider.of<DebtsProvider>(context, listen: false).fetchDebt(debtId);
        Navigator.of(context).pop();
        hideSpinner();
      } catch(error) {
        hideSpinner();
        throw error;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 8.0),
      alignment: Alignment.center,
      child: spinnerContainer(
        spinner: ButtonSpinner(),
        replacement: FlatButton(
          child: Text('DELETE'),
          textColor: Theme.of(context).errorColor,
          onPressed: () => _deleteOperation(context),
        )
      ),
    );
  }
}
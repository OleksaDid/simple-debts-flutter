import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/helpers/dialog_helper.dart';
import 'package:simpledebts/mixins/spinner_state.dart';
import 'package:simpledebts/providers/debts_provider.dart';
import 'package:simpledebts/providers/operations_provider.dart';
import 'package:simpledebts/widgets/common/button_spinner.dart';

class DeleteOperationButton extends StatefulWidget {
  final String operationId;
  final String debtId;

  DeleteOperationButton({
    @required this.operationId,
    @required this.debtId
  });

  @override
  _DeleteOperationButtonState createState() => _DeleteOperationButtonState();
}

class _DeleteOperationButtonState extends State<DeleteOperationButton> with SpinnerState {

  Future<void> _deleteOperation() async {
    final deleteOperation = await DialogHelper.showDeleteDialog(context, 'Delete this operation?');
    if(deleteOperation == true) {
      showSpinner();
      try {
        await Provider.of<OperationsProvider>(context, listen: false).deleteOperation(widget.operationId);
        await Provider.of<DebtsProvider>(context, listen: false).fetchDebt(widget.debtId);
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
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if(!spinnerVisible) FlatButton(
            child: Text('DELETE'),
            textColor: Theme.of(context).errorColor,
            onPressed: _deleteOperation,
          ),
          if(spinnerVisible) ButtonSpinner()
        ],
      ),
    );
  }
}
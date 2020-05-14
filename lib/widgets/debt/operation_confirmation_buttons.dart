import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/spinner_state.dart';
import 'package:simpledebts/providers/debts_provider.dart';
import 'package:simpledebts/providers/operations_provider.dart';
import 'package:simpledebts/widgets/common/button_spinner.dart';

class OperationConfirmationButtons extends StatefulWidget {
  final String operationId;
  final String debtId;
  final MainAxisSize rowSize;

  OperationConfirmationButtons({
    @required this.operationId,
    @required this.debtId,
    this.rowSize = MainAxisSize.min,
  });

  @override
  _OperationConfirmationButtonsState createState() => _OperationConfirmationButtonsState();
}

class _OperationConfirmationButtonsState extends State<OperationConfirmationButtons> with SpinnerState {

  Future<void> _acceptOperation() async {
    showSpinner();
    try {
      await Provider.of<OperationsProvider>(context, listen: false).acceptOperation(widget.operationId);
      await Provider.of<DebtsProvider>(context, listen: false).fetchDebt(widget.debtId);
    } catch(error) {
      ErrorHelper.handleError(error);
    }
    hideSpinner();
  }

  Future<void> _declineOperation() async {
    showSpinner();
    try {
      await Provider.of<OperationsProvider>(context, listen: false).declineOperation(widget.operationId);
      await Provider.of<DebtsProvider>(context, listen: false).fetchDebt(widget.debtId);
    } catch(error) {
      ErrorHelper.handleError(error);
    }
    hideSpinner();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: widget.rowSize,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        if(!spinnerVisible) FlatButton(
          child: Text('DECLINE'),
          onPressed: _declineOperation,
          textColor: Theme.of(context).accentColor,
        ),
        if(!spinnerVisible) FlatButton(
          child: Text('ACCEPT'),
          onPressed: _acceptOperation,
          textColor: Theme.of(context).accentColor,
        ),
        if(spinnerVisible) ButtonSpinner(radius: 20,)
      ],
    );
  }
}
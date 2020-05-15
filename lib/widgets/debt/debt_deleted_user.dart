import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/spinner_state.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/providers/debts_provider.dart';
import 'package:simpledebts/widgets/common/button_spinner.dart';
import 'package:simpledebts/widgets/debt/operations_list_widget.dart';

class DebtDeletedUser extends StatefulWidget {
  final Debt debt;

  DebtDeletedUser({
    @required this.debt
  });

  @override
  _DebtDeletedUserState createState() => _DebtDeletedUserState();
}

class _DebtDeletedUserState extends State<DebtDeletedUser> with SpinnerState {
  Future<void> _acceptInfo(BuildContext context) async {
    showSpinner();
    try {
      await Provider.of<DebtsProvider>(context, listen: false).acceptUserDeletedFromDebt(widget.debt.id);
    } catch(error) {
      ErrorHelper.handleError(error);
    }
    hideSpinner();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.only(
            top: 20,
            left: 20,
            right: 20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Another user has left. You can continue using this debt with virtual user',
                textAlign: TextAlign.center,
              ),
              if(!spinnerVisible) FlatButton(
                child: Text('OK'),
                textColor: Theme.of(context).accentColor,
                onPressed: () => _acceptInfo(context),
              ),
              if(spinnerVisible) ButtonSpinner(radius: 20,)
            ],
          ),
        ),
        Divider(thickness: 2,),
        Expanded(
          child: OperationsListWidget(
            operations: widget.debt.moneyOperations,
            debt: widget.debt,
          ),
        )
      ],
    );
  }
}
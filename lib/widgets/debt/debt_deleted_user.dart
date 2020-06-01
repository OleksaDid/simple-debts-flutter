import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/spinner_store_use.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/providers/debts_provider.dart';
import 'package:simpledebts/widgets/common/button_spinner.dart';
import 'package:simpledebts/widgets/debt/operations_list_widget.dart';

class DebtDeletedUser extends StatelessWidget with SpinnerStoreUse {
  final Debt debt;

  DebtDeletedUser({
    @required this.debt
  });

  Future<void> _acceptInfo(BuildContext context) async {
    showSpinner();
    try {
      await Provider.of<DebtsProvider>(context, listen: false).acceptUserDeletedFromDebt(debt.id);
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
              spinnerContainer(
                spinner: ButtonSpinner(radius: 20,),
                replacement: FlatButton(
                  child: Text('OK'),
                  textColor: Theme.of(context).accentColor,
                  onPressed: () => _acceptInfo(context),
                )
              )
            ],
          ),
        ),
        Divider(thickness: 2,),
        Expanded(
          child: OperationsListWidget(
            operations: debt.moneyOperations,
            debt: debt,
          ),
        )
      ],
    );
  }
}
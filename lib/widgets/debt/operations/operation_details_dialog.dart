import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/intl.dart';
import 'package:simpledebts/helpers/dialog_helper.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/models/debts/operation.dart';
import 'package:simpledebts/store/auth.store.dart';
import 'package:simpledebts/widgets/debt/operations/delete_operation_button.dart';
import 'package:simpledebts/widgets/debt/operations/operation_confirmation_buttons.dart';

class OperationDetailsDialog extends StatelessWidget {
  final authStore = GetIt.instance<AuthStore>();
  final Operation operation;
  final Debt debt;

  OperationDetailsDialog({
    @required this.operation,
    @required this.debt,
  });

  Widget _buildBottomBlock(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20,),
        if(operation.status == OperationStatus.CANCELLED) Text(
          'Operation was canceled by ${operation.cancelledBy == authStore.currentUser.id ? 'you' : debt.user.name}',
          style: TextStyle(
              color: Theme.of(context).colorScheme.secondary
          ),
        ),
        if(operation.status == OperationStatus.CREATION_AWAITING && operation.statusAcceptor == debt.user.id) Text(
          'Waiting for ${debt.user.name} to confirm operation',
          style: TextStyle(
              color: Theme.of(context).accentColor
          ),
        ),
        if(operation.status == OperationStatus.CREATION_AWAITING && operation.statusAcceptor != debt.user.id) Container(
          alignment: Alignment.centerRight,
          child: OperationConfirmationButtons(
            operationId: operation.id,
            rowSize: MainAxisSize.max,
            onConfirm: (context) => Navigator.of(context).pop(),
          ),
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final youGiveMoney = operation.moneyReceiver == debt.user.id;
    final String formattedDate = DateFormat().add_yMMMd().format(operation.date);
    final Color operationColor = operation.status == OperationStatus.UNCHANGED
        ? youGiveMoney
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.secondary
        : Theme.of(context).textTheme.headline6.color;

    return DialogHelper.getThemedDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(authStore.currentUser.picture),
                radius: 28,
                backgroundColor: Colors.white,
              ),
              SizedBox(width: 20,),
              Icon(
                youGiveMoney ? Icons.arrow_forward : Icons.arrow_back,
                color: operationColor,
                size: 38,
              ),
              SizedBox(width: 20,),
              CircleAvatar(
                backgroundImage: NetworkImage(debt.user.picture),
                radius: 28,
                backgroundColor: Colors.white,
              )
            ],
          ),
          SizedBox(height: 10,),
          Container(
            width: double.infinity,
            alignment: youGiveMoney ? Alignment.centerLeft : Alignment.centerRight,
            child: Text(
              '${debt.currency} ${operation.moneyAmount.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: operationColor
              ),
            ),
          ),
          SizedBox(height: 20,),
          Text(operation.description, style: TextStyle(fontSize: 18),),
          Text(formattedDate, textAlign: TextAlign.start,),
          if(operation.status != OperationStatus.UNCHANGED) _buildBottomBlock(context),
          if(debt.type == DebtAccountType.SINGLE_USER) DeleteOperationButton(
            operationId: operation.id,
            debtId: debt.id,
          )
        ],
      )
    );
  }

}
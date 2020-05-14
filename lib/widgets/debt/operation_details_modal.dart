import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/helpers/app_dialog.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/models/debts/operation.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/providers/auth_provider.dart';
import 'package:simpledebts/widgets/debt/operation_confirmation_buttons.dart';

class OperationDetailsModal extends StatelessWidget {
  final Operation operation;
  final Debt debt;

  OperationDetailsModal({
    @required this.operation,
    @required this.debt,
  });

  Widget _buildBottomBlock(BuildContext context, User currentUser) {
    return Column(
      children: [
        SizedBox(height: 10,),
        Divider(),
        SizedBox(height: 10,),
        if(operation.status == OperationStatus.CANCELLED) Text(
          'Operation was canceled by ${operation.cancelledBy == currentUser.id ? 'you' : debt.user.name}',
          style: TextStyle(
            color: Theme.of(context).errorColor
          ),
        ),
        if(operation.status == OperationStatus.CREATION_AWAITING && operation.statusAcceptor == debt.user.id) Text(
          'Waiting for ${debt.user.name} to confirm operation',
          style: TextStyle(
              color: Theme.of(context).accentColor
          ),
        ),
        if(operation.status == OperationStatus.CREATION_AWAITING && operation.statusAcceptor != debt.user.id) OperationConfirmationButtons(
          operationId: operation.id,
          debtId: debt.id,
          rowSize: MainAxisSize.max,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final youGiveMoney = operation.moneyReceiver == debt.user.id;
    final User currentUser = Provider.of<AuthProvider>(context, listen: false).authData?.user;
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
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                backgroundImage: NetworkImage(currentUser.picture),
                radius: 28,
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
              )
            ],
          ),
          SizedBox(height: 10,),
          Container(
            width: double.infinity,
            alignment: Alignment.center,
            child: Text(
              '${debt.currency} ${operation.moneyAmount.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: operationColor
              ),
            ),
          ),
          SizedBox(height: 10,),
          Divider(),
          SizedBox(height: 10,),
          Text(operation.description, style: TextStyle(fontSize: 18),),
          Text(formattedDate, textAlign: TextAlign.start,),
          if(operation.status != OperationStatus.UNCHANGED) _buildBottomBlock(context, currentUser)
        ],
      )
    );
  }

}
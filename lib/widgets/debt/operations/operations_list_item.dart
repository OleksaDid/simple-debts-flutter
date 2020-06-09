import 'package:flutter/material.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/models/debts/operation.dart';
import 'package:simpledebts/widgets/debt/operations/operation_confirmation_buttons.dart';
import 'package:simpledebts/widgets/debt/operations/operation_details_dialog.dart';

class OperationsListItem extends StatelessWidget {
  final Operation operation;
  final Debt debt;

  OperationsListItem({
    @required this.operation,
    @required this.debt,
  });

  void _openOperationDetails(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => OperationDetailsDialog(
        operation: operation,
        debt: debt,
      )
    );
  }

  Color _getOperationColor(BuildContext context) {
    if(operation.status == OperationStatus.CANCELLED || operation.status == OperationStatus.CREATION_AWAITING) {
      return Theme.of(context).textTheme.headline6.color;
    }

    return operation.moneyReceiver == debt.user.id
        ? Theme.of(context).colorScheme.primary
        : Theme.of(context).colorScheme.secondary;
  }

  Widget _buildTrailingBlock(BuildContext context) {
    if(operation.status == OperationStatus.CREATION_AWAITING) {
      if(operation.statusAcceptor == debt.user.id) {
        return Text('WAITING FOR ACCEPT', style: TextStyle(color: Theme.of(context).accentColor),);
      } else {
        return OperationConfirmationButtons(
          operationId: operation.id,
        );
      }
    }
    if(operation.status == OperationStatus.CANCELLED) {
      return Text('CANCELED', style: TextStyle(color: Theme.of(context).errorColor),);
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        InkWell(
          onTap: () => _openOperationDetails(context),
          child: ListTile(
            leading: Icon(
              operation.moneyReceiver == debt.user.id
                  ? Icons.arrow_upward
                  : Icons.arrow_downward,
              size: 38,
              color: _getOperationColor(context),
            ),
            title: Text(
              operation.moneyAmount.toStringAsFixed(0),
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold
              ),
            ),
            subtitle: Text(
              operation.description,
              overflow: TextOverflow.fade,
              maxLines: 1,
              softWrap: false,
            ),
            trailing: _buildTrailingBlock(context),
          ),
        ),
        Divider(height: 2,)
      ],
    );
  }

}
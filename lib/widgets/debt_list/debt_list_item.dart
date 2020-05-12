import 'package:flutter/material.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/screens/debt_screen.dart';

class DebtListItem extends StatelessWidget {
  final Debt debt;

  DebtListItem(this.debt);
  
  void _navigateToDebtDetails(BuildContext context) {
    Navigator.of(context).pushNamed(DebtScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => _navigateToDebtDetails(context),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 10
        ),
        leading: CircleAvatar(
          backgroundImage: NetworkImage(debt.user.picture),
          radius: 28,
        ),
        title: Text(
          debt.user.name,
          style: Theme.of(context).textTheme.headline6,
        ),
        subtitle: Text(
          '${debt.currency} ${debt.summary.toStringAsFixed(0)}',
          style: TextStyle(
            color: debt.getSummaryColor(context)
          ),
        ),
        trailing: Visibility(
          visible: debt.hasNotification,
          child: Container(
            height: 16,
            width: 16,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: Theme.of(context).accentColor,
            ),
          ),
        ),
      ),
    );
  }

}
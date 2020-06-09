import 'package:flutter/material.dart';
import 'package:simpledebts/models/common/route/id_route_argument.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/screens/debt_screen.dart';
import 'package:simpledebts/widgets/common/hero_image_circle.dart';

class DebtListItem extends StatelessWidget {
  final Debt debt;

  DebtListItem(this.debt);
  
  void _navigateToDebtDetails(BuildContext context) {
    Navigator.of(context).pushNamed(DebtScreen.routeName, arguments: IdRouteArgument(debt.id));
  }

  Widget _buildTrailing(BuildContext context) {
    if(debt.status == DebtStatus.CREATION_AWAITING || debt.status == DebtStatus.CONNECT_USER) {
      return debt.isUserStatusAcceptor
          ? Text('NEW', style: TextStyle(color: Theme.of(context).accentColor))
          : Text('WAITING', style: TextStyle(color: Theme.of(context).accentColor));
    }
    if(debt.status == DebtStatus.USER_DELETED) {
      return Text('USER LEFT', style: TextStyle(color: Theme.of(context).colorScheme.secondary),);
    }
    if(debt.status == DebtStatus.CHANGE_AWAITING && debt.isUserStatusAcceptor) {
      return Text('NEW OPERATIONS', style: TextStyle(color: Theme.of(context).accentColor),);
    }
    return SizedBox();
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
        leading: HeroImageCircle(
          diameter: 56,
          image: NetworkImage(debt.user.picture),
          tag: debt.user.id,
        ),
        title: Text(
          debt.user.name,
          style: Theme.of(context).textTheme.headline6,
          overflow: TextOverflow.fade,
          softWrap: false,
          maxLines: 1,
        ),
        subtitle: Text(
          '${debt.currency} ${debt.summary.toStringAsFixed(0)}',
          style: TextStyle(
              color: debt.getSummaryColor(context)
          ),
        ),
        trailing: debt.status != DebtStatus.UNCHANGED ? _buildTrailing(context) : null
      ),
    );
  }

}
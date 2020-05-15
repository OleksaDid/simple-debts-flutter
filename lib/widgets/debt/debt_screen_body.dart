import 'package:flutter/material.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/widgets/common/top_block.dart';
import 'package:simpledebts/widgets/common/user_top_block.dart';
import 'package:simpledebts/widgets/debt/debt_creation_accept.dart';
import 'package:simpledebts/widgets/debt/debt_deleted_user.dart';
import 'package:simpledebts/widgets/debt/operations_list_widget.dart';


class DebtScreenBody extends StatelessWidget {
  final Debt debt;

  DebtScreenBody({
    @required this.debt,
  });

  String _getTitleText(Debt debt) {
    final Map<MoneyReceiveStatus, String> titles = {
      MoneyReceiveStatus.None: '${debt.user.name} \n owes you nothing',
      MoneyReceiveStatus.YouTake: 'You owe ${debt.user.name} \n ${debt.summary.toStringAsFixed(2)} ${debt.currency}',
      MoneyReceiveStatus.YouGive: '${debt.user.name} owes you \n ${debt.summary.toStringAsFixed(2)} ${debt.currency}',
    };

    return titles[debt?.moneyReceiveStatus];
  }

  Widget _mainBuilder() {
    if(debt.status == DebtStatus.CREATION_AWAITING) {
      return DebtCreationAccept(
        debt: debt,
      );
    }
    if(debt.status == DebtStatus.USER_DELETED  && debt.statusAcceptor != null) {
      return DebtDeletedUser(
        debt: debt
      );
    }
    return OperationsListWidget(
      operations: debt.moneyOperations,
      debt: debt,
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        TopBlock(
          color: debt?.moneyReceiveStatus != MoneyReceiveStatus.YouTake ? BlockColor.Green : BlockColor.Red,
          child: UserTopBlock(
            imageUrl: debt.user.picture,
            title: _getTitleText(debt),
          ),
        ),
        Expanded(
          child: _mainBuilder()
        ),
      ],
    );
  }

}
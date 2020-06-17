import 'package:flutter/material.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/widgets/common/top_block.dart';
import 'package:simpledebts/widgets/common/user_top_block.dart';
import 'package:simpledebts/widgets/debt/connect_user/connect_user_block.dart';
import 'package:simpledebts/widgets/debt/debt_creation_accept.dart';
import 'package:simpledebts/widgets/debt/debt_deleted_user.dart';
import 'package:simpledebts/widgets/debt/operations/operations_list_widget.dart';


class DebtScreenBody extends StatelessWidget {
  final Debt debt;

  DebtScreenBody({
    @required this.debt,
  });

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

    if(debt.status == DebtStatus.CONNECT_USER) {
      return ConnectUserBlock(
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
            imageTag: debt?.heroImageTag,
            imageUrl: debt?.user?.picture,
            title: debt?.getTitleText(debt.user),
          ),
        ),
        Expanded(
          child: _mainBuilder()
        ),
      ],
    );
  }

}
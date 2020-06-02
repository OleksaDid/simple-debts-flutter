import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/models/debts/operation.dart';
import 'package:simpledebts/store/auth_data_store.dart';
import 'package:simpledebts/store/debt.store.dart';
import 'package:simpledebts/widgets/common/empty_list_placeholder.dart';
import 'package:simpledebts/widgets/debt/add_operation_widget.dart';
import 'package:simpledebts/widgets/debt/bottom_buttons_row.dart';
import 'package:simpledebts/widgets/debt/debt_screen_bottom_button.dart';
import 'package:simpledebts/widgets/debt/operations_list_item.dart';

class OperationsListWidget extends StatelessWidget {
  final authStore = GetIt.instance<AuthDataStore>();
  final List<Operation> operations;
  final Debt debt;
  final bool showBottomButtons;

  OperationsListWidget({
    @required this.operations,
    @required this.debt,
    this.showBottomButtons = true,
  });

  Widget _buildMainBlock(BuildContext context, AsyncSnapshot snapshot) {
    if(snapshot.error != null) {
      return Center(
        child: Text('An error has occured. Try again later'),
      );
    }
    if(snapshot.connectionState == ConnectionState.waiting) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }
    return operations.length == 0
        ? EmptyListPlaceholder(
          icon: Icons.account_balance_wallet,
          title: 'No operations yet',
          subtitle: 'Press one of the buttons below to add one',
        )
        : RefreshIndicator(
          onRefresh: () => _fetchOperations(forceRefresh: true),
          child: ListView.builder(
            itemCount: operations.length,
            itemBuilder: (context, index) => OperationsListItem(
              operation: operations[index],
              debt: debt,
            )
          ),
        );
  }

  Future<Debt> _fetchOperations({bool forceRefresh = false}) async {
    if(debt.moneyOperations == null || forceRefresh) {
      return GetIt.instance<DebtStore>().fetchDebt(debt.id);
    } else {
      return debt;
    }
  }

  Future<void> _addOperation(BuildContext context, Debt debt, String moneyReceiver) async {
    await showDialog<Operation>(
      context: context,
      builder: (context) => AddOperationWidget(
        debt: debt,
        moneyReceiver: moneyReceiver,
        onOperationAdded: () => _fetchOperations(forceRefresh: true),
      )
    );
  }

  @override
  Widget build(BuildContext context) {

    return Column(
      children: [
        Expanded(
          child: FutureBuilder<Debt>(
            future: _fetchOperations(),
            builder: _buildMainBlock
          ),
        ),
        if(showBottomButtons) BottomButtonsRow(
          primaryButton: DebtScreenBottomButton(
            title: 'GIVE',
            onTap: () => _addOperation(context, debt,  debt.user.id),
            color: Theme.of(context).colorScheme.primary,
          ),
          secondaryButton: DebtScreenBottomButton(
            title: 'TAKE',
            onTap: () => _addOperation(context, debt, authStore.currentUser.id),
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }

}
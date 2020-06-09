import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/models/common/errors/failure.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/models/debts/operation.dart';
import 'package:simpledebts/store/auth.store.dart';
import 'package:simpledebts/store/debt.store.dart';
import 'package:simpledebts/widgets/common/empty_list_placeholder.dart';
import 'package:simpledebts/widgets/debt/operations/add_operation_dialog.dart';
import 'package:simpledebts/widgets/debt/bottom_buttons_row.dart';
import 'package:simpledebts/widgets/debt/debt_screen_bottom_button.dart';
import 'package:simpledebts/widgets/debt/operations/operations_list_item.dart';

class OperationsListWidget extends StatefulWidget {
  final List<Operation> operations;
  final Debt debt;
  final bool showBottomButtons;


  OperationsListWidget({
    @required this.operations,
    @required this.debt,
    this.showBottomButtons = true,
  });

  @override
  _OperationsListWidgetState createState() => _OperationsListWidgetState();
}

class _OperationsListWidgetState extends State<OperationsListWidget> {
  final authStore = GetIt.instance<AuthStore>();

  Future<Debt> _futureOperations;

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
    return widget.operations.length == 0
        ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            EmptyListPlaceholder(
              icon: Icons.account_balance_wallet,
              title: 'No operations yet',
              subtitle: 'Press one of the buttons below to add one',
              onRefresh: () => _fetchOperations(forceRefresh: true),
            ),
          ],
        )
        : RefreshIndicator(
          onRefresh: () => _fetchOperations(forceRefresh: true),
          child: ListView.builder(
            itemCount: widget.operations.length,
            itemBuilder: (context, index) => OperationsListItem(
              operation: widget.operations[index],
              debt: widget.debt,
            )
          ),
        );
  }

  Future<Debt> _fetchOperations({bool forceRefresh = false}) async {
    if(widget.debt.moneyOperations == null || forceRefresh) {
      try {
        return GetIt.instance<DebtStore>().fetchDebt();
      } on Failure catch(error) {
        ErrorHelper.showErrorSnackBar(context, error.message);
      }
    } else {
      return widget.debt;
    }
  }

  Future<void> _addOperation(BuildContext context, Debt debt, String moneyReceiver) async {
    await showDialog<Operation>(
      context: context,
      builder: (context) => AddOperationDialog(
        debt: debt,
        moneyReceiver: moneyReceiver,
      )
    );
  }

  @override
  Widget build(BuildContext context) {
    if(_futureOperations == null) {
      _futureOperations = _fetchOperations();
    }

    return Column(
      children: [
        Expanded(
          child: FutureBuilder<Debt>(
            future: _futureOperations,
            builder: _buildMainBlock
          ),
        ),
        if(widget.showBottomButtons) BottomButtonsRow(
          primaryButton: DebtScreenBottomButton(
            title: 'GIVE',
            onTap: () => _addOperation(context, widget.debt,  widget.debt.user.id),
            color: Theme.of(context).colorScheme.primary,
          ),
          secondaryButton: DebtScreenBottomButton(
            title: 'TAKE',
            onTap: () => _addOperation(context, widget.debt, authStore.currentUser.id),
            color: Theme.of(context).colorScheme.secondary,
          ),
        ),
      ],
    );
  }
}
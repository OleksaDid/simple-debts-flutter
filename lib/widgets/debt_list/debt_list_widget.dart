import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/providers/currency_provider.dart';
import 'package:simpledebts/providers/debts_provider.dart';
import 'package:simpledebts/widgets/common/empty_list_placeholder.dart';
import 'package:simpledebts/widgets/debt_list/debt_list_item.dart';

class DebtListWidget extends StatelessWidget {

  Future<void> _refreshDebtsList(BuildContext context) async {
    await Provider.of<CurrencyProvider>(context, listen: false).fetchAndSetCurrencies();
    return Provider.of<DebtsProvider>(context, listen: false).fetchAndSetDebtList();
  }

  List<Debt> _getDebtList(BuildContext context) {
    return Provider.of<DebtsProvider>(context).debtList.debts;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _refreshDebtsList(context),
      builder: (context, snapshot) {
        if(snapshot.error != null) {
          return Center(
            child: Text('Something went wrong. Try again later'),
          );
        }
        if(snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else {
          final debts = _getDebtList(context);

          if(debts.length == 0) {
            return EmptyListPlaceholder(
              icon: Icons.assistant,
              title: 'There are no items yet',
              subtitle: 'press \'+\' to add the first debt',
            );
          } else {
            return RefreshIndicator(
              onRefresh: () => _refreshDebtsList(context),
              child: ListView.builder(
                  itemCount: debts.length,
                  itemBuilder: (context, index) => DebtListItem(debts[index])
              ),
            );
          }
        }
      }
    );
  }

}
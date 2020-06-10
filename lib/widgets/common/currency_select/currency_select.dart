import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/store/currency.store.dart';
import 'package:simpledebts/widgets/common/currency_select/currency_select.store.dart';

class CurrencySelect extends StatelessWidget {
  final CurrencySelectStore _currencyStore = CurrencySelectStore();

  final void Function(String currency) onSelect;
  final String defaultCurrency;

  CurrencySelect({
    @required this.defaultCurrency,
    @required this.onSelect
  });

  void _openCurrencySelector(BuildContext context) {
    final currencies = getCurrencies();
    new Picker(
        adapter: PickerDataAdapter<String>(
          data: currencies.map((currency) => PickerItem(
            text: Text(currency),
            value: currency
          )).toList()..sort((a, b) => a.value.compareTo(b.value))
        ),
        changeToFirst: true,
        hideHeader: false,
        height: 180,
        onConfirm: (Picker picker, List value) => _selectCurrency(picker.adapter.text.substring(1, 4))
    ).showModal(context); //_scaffoldKey.currentState);
  }

  void _selectCurrency(String currency) {
    _currencyStore.setCurrency(currency);
    onSelect(currency);
  }

  List<String> getCurrencies() {
    return GetIt.instance<CurrencyStore>().setOfCurrencyIso;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Debt currency: ',
              style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontSize: 18
              )
            ),
            StreamBuilder<String>(
              stream: _currencyStore.currency$,
              builder: (context, snapshot) {
                return Text(
                  snapshot.data ?? defaultCurrency,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).textTheme.headline1.color,
                      fontSize: 18
                  )
                );
              }
            )
          ],
        ),
        FlatButton(
          child: Text('CHANGE CURRENCY'),
          textColor: Theme.of(context).primaryColor,
          onPressed: () => _openCurrencySelector(context),
        )
      ],
    );
  }

}
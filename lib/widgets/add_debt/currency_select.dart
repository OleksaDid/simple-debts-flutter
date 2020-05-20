import 'package:flutter/material.dart';
import 'package:flutter_picker/flutter_picker.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/store/currency_store.dart';

class CurrencySelect extends StatelessWidget {
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
        onConfirm: (Picker picker, List value) => onSelect(picker.adapter.text.substring(1, 4))
    ).showModal(context); //_scaffoldKey.currentState);
  }

  List<String> getCurrencies() {
    return GetIt.instance<CurrencyStore>().setOfCurrencyIso;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        RichText(
          text: TextSpan(
            children: [
              TextSpan(
                text: 'Debt currency: ',
                style: TextStyle(
                  color: Theme.of(context).textTheme.headline1.color,
                  fontSize: 18
                )
              ),
              TextSpan(
                text: defaultCurrency,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).textTheme.headline1.color,
                  fontSize: 18
                )
              )
            ]
          )
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
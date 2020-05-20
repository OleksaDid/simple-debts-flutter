// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$CurrencyStore on _CurrencyStore, Store {
  Computed<List<String>> _$setOfCurrencyIsoComputed;

  @override
  List<String> get setOfCurrencyIso => (_$setOfCurrencyIsoComputed ??=
          Computed<List<String>>(() => super.setOfCurrencyIso,
              name: '_CurrencyStore.setOfCurrencyIso'))
      .value;

  final _$currenciesAtom = Atom(name: '_CurrencyStore.currencies');

  @override
  ObservableList<Currency> get currencies {
    _$currenciesAtom.reportRead();
    return super.currencies;
  }

  @override
  set currencies(ObservableList<Currency> value) {
    _$currenciesAtom.reportWrite(value, super.currencies, () {
      super.currencies = value;
    });
  }

  final _$_CurrencyStoreActionController =
      ActionController(name: '_CurrencyStore');

  @override
  Future<void> fetchCurrencies() {
    final _$actionInfo = _$_CurrencyStoreActionController.startAction(
        name: '_CurrencyStore.fetchCurrencies');
    try {
      return super.fetchCurrencies();
    } finally {
      _$_CurrencyStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
currencies: ${currencies},
setOfCurrencyIso: ${setOfCurrencyIso}
    ''';
  }
}

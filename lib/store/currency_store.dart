import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:simpledebts/models/common/currency/currency.dart';
import 'package:simpledebts/services/currency_service.dart';

part 'currency_store.g.dart';

class CurrencyStore = _CurrencyStore with _$CurrencyStore;

abstract class _CurrencyStore with Store {
  final _currencyService = GetIt.instance<CurrencyService>();

  @observable
  var currencies = ObservableList<Currency>();

  @computed
  List<String> get setOfCurrencyIso {
    return currencies.map((currency) => currency.currency)
        .where((currency) => currency.isNotEmpty)
        .toSet()
        .toList();
  }

  @action
  Future<void> fetchCurrencies() => _currencyService.fetchAndSetCurrencies(currencies)
      .then((value) => currencies.length == 0 ? currencies.addAll(value) : null);

}
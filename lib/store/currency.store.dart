import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simpledebts/services/shared_preferences_service.dart';
import 'package:simpledebts/models/common/currency/currency.dart';
import 'package:simpledebts/services/currency_service.dart';

class CurrencyStore {
  final _currencyService = GetIt.instance<CurrencyService>();
  final SharedPreferencesService _sharedPreferencesService = GetIt.instance<SharedPreferencesService>();

  final BehaviorSubject<List<Currency>> _currencies = BehaviorSubject.seeded([]);

  Stream<List<Currency>> get currencies$ => _currencies.stream;

  List<Currency> get currencies => _currencies.value;
  List<String> get setOfCurrencyIso => currencies.map((currency) => currency.currency)
      .where((currency) => currency.isNotEmpty)
      .toSet()
      .toList();

  Future<void> getCachedCurrencies() => _sharedPreferencesService
      .getCurrencies()
      ..then(_updateCurrencies);

  Future<void> fetchCurrencies() => currencies != null && currencies.length == 0
      ? _currencyService
        .fetchAndSetCurrencies(currencies)
        .then(_updateCurrencies)
      : null;

  void _updateCurrencies(List<Currency> currencies) {
    if(currencies != null) {
      _sharedPreferencesService.saveCurrencies(currencies);
    }
    _currencies.add(currencies);
  }
}
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simpledebts/models/common/currency/currency.dart';
import 'package:simpledebts/services/currency_service.dart';

class CurrencyStore {
  final _currencyService = GetIt.instance<CurrencyService>();

  final BehaviorSubject<List<Currency>> _currencies = BehaviorSubject.seeded([]);

  Stream<List<Currency>> get currencies$ => _currencies.stream;

  List<Currency> get currencies => _currencies.value;
  List<String> get setOfCurrencyIso => currencies.map((currency) => currency.currency)
      .where((currency) => currency.isNotEmpty)
      .toSet()
      .toList();

  Future<void> fetchCurrencies() => _currencyService
      .fetchAndSetCurrencies(currencies)
      .then((value) => currencies.length == 0 ? _currencies.add(value) : null);
}
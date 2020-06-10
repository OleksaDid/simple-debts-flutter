import 'package:rxdart/rxdart.dart';

class CurrencySelectStore {
  final BehaviorSubject<String> _currency = BehaviorSubject();

  Stream<String> get currency$ => _currency.stream;

  void setCurrency(String currency) => _currency.add(currency);
}
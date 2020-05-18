import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/http_service_use.dart';
import 'package:simpledebts/models/common/currency/currency.dart';

class CurrencyProvider with ChangeNotifier, HttpServiceUse {

  List<Currency> _currencies = [];
  
  List<Currency> get currencies {
    return [..._currencies];
  }

  List<String> get setOfCurrencyIso {
    return currencies.map((currency) => currency.currency)
        .where((currency) => currency.isNotEmpty)
        .toSet()
        .toList();
  }
  
  Future<void> fetchAndSetCurrencies() async {
    if(_currencies.length == 0) {
      try {
        final url = '/common/currency';
        final response = await http.get(url);
        final List currencies = response.data;
        _currencies = currencies
            .map((currency) => Currency.fromJson(currency))
            .toList();
        notifyListeners();
      } on DioError catch(error) {
        ErrorHelper.handleDioError(error);
      }
    }
  }

  Currency getCurrencyByIso(String currencyIso) {
    return _currencies.firstWhere((currency) => currency.currency == currencyIso);
  }

}
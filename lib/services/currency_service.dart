import 'package:dio/dio.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/http_auth_service_use.dart';
import 'package:simpledebts/models/common/currency/currency.dart';

class CurrencyService with HttpAuthServiceUse {

  Future<List<Currency>> fetchAndSetCurrencies(List<Currency> currencies) async {
    if(currencies.length == 0) {
      try {
        final url = '/common/currency';
        final response = await http.get(url);
        final List fetchedCurrencies = response.data;
        return fetchedCurrencies
            .map((currency) => Currency.fromJson(currency))
            .toList();
      } on DioError catch(error) {
        ErrorHelper.handleDioError(error);
        return currencies;
      }
    }
    return currencies;
  }

}
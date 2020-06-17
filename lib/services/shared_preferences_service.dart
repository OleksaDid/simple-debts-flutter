import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:simpledebts/models/auth/auth_data.dart';
import 'package:simpledebts/models/common/currency/currency.dart';
import 'package:simpledebts/models/common/errors/failure.dart';
import 'package:simpledebts/models/debts/debt_list.dart';

class SharedPreferencesService {
  final _authDataKey = 'authData';
  final _debtListKey = 'debtList';
  final _currenciesKey = 'currencies';

  SharedPreferences _preferences;

  Future<void> init() async {
    if (_preferences == null) {
      _preferences = await SharedPreferences.getInstance();
    }
  }

  Future<AuthData> getAuthData() async {
    final data = await _getData(_authDataKey);
    return data != null
        ? AuthData.fromJson(data)
        : null;
  }

  Future<void> saveAuthData(AuthData authData) async {
    return _saveData(authData.toJson(), _authDataKey);
  }

  Future<void> saveCurrencies(List<Currency> currencies) async {
    try {
      final data = jsonEncode(currencies.map((e) => e.toJson()).toList());
      return _preferences.setString(_currenciesKey, data);
    } catch(error) {
      print(error);
      throw Failure(error: error);
    }
  }

  Future<List<Currency>> getCurrencies() async {
    if(_preferences.containsKey(_currenciesKey)) {
      final data = _preferences.getString(_currenciesKey);
      final json = List<dynamic>.from(jsonDecode(data));
      return json.map((e) => Currency.fromJson(e)).toList();
    }
    return null;
  }

  Future<DebtList> getDebtList() async {
    final data = await _getData(_debtListKey);
    return data != null
        ? DebtList.fromJson(data)
        : null;
  }

  Future<void> saveDebtList(DebtList debtList) async {
    return _saveData(debtList.toJson(), _debtListKey);
  }

  Future<void> removeAllData() async {
    try {
      return _preferences.clear();
    } catch(error) {
      print(error);
      throw Failure(error: error);
    }
  }


  Future<void> _saveData(Map<dynamic, dynamic> json, String key) async {
    try {
      final data = jsonEncode(json);
      return _preferences.setString(key, data);
    } catch(error) {
      print(error);
      throw Failure(error: error);
    }
  }

  Future<Map<dynamic, dynamic>> _getData(String key) async {
    if(_preferences.containsKey(key)) {
      final data = _preferences.getString(key);
      final json = Map<String, dynamic>.from(jsonDecode(data));
      return json;
    }
    return null;
  }
}
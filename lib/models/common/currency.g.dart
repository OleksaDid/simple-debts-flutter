// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'currency.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Currency _$CurrencyFromJson(Map<String, dynamic> json) {
  return Currency(
    countryName: json['countryName'] as String,
    iso: json['iso'] as String,
    currency: json['currency'] as String,
    symbol: json['symbol'] as String,
  );
}

Map<String, dynamic> _$CurrencyToJson(Currency instance) => <String, dynamic>{
      'countryName': instance.countryName,
      'iso': instance.iso,
      'currency': instance.currency,
      'symbol': instance.symbol,
    };

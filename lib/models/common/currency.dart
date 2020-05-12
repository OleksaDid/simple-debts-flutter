import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'currency.g.dart';

@JsonSerializable()
class Currency {
  final String countryName;
  final String iso;
  final String currency;
  final String symbol;

  const Currency({
    @required this.countryName,
    @required this.iso,
    @required this.currency,
    @required this.symbol
  });

  factory Currency.fromJson(Map<String, dynamic> json) => _$CurrencyFromJson(json);
  Map<String, dynamic> toJson() => _$CurrencyToJson(this);
}
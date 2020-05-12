import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/models/debts/debt_list_summary.dart';

part 'debt_list.g.dart';

@JsonSerializable(explicitToJson: true)
class DebtList {
  final List<Debt> debts;
  final DebtListSummary summary;

  const DebtList({
    @required this.debts,
    @required this.summary
  });

  factory DebtList.fromJson(Map<String, dynamic> json) => _$DebtListFromJson(json);
  Map<String, dynamic> toJson() => _$DebtListToJson(this);
}


import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'debt_list_summary.g.dart';

@JsonSerializable()
class DebtListSummary {
  final double toGive;
  final double toTake;

  const DebtListSummary({
    @required this.toGive,
    @required this.toTake
  });

  factory DebtListSummary.fromJson(Map<String, dynamic> json) => _$DebtListSummaryFromJson(json);
  Map<String, dynamic> toJson() => _$DebtListSummaryToJson(this);
}
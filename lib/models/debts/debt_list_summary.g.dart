// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_list_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DebtListSummary _$DebtListSummaryFromJson(Map<String, dynamic> json) {
  return DebtListSummary(
    toGive: (json['toGive'] as num)?.toDouble(),
    toTake: (json['toTake'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$DebtListSummaryToJson(DebtListSummary instance) =>
    <String, dynamic>{
      'toGive': instance.toGive,
      'toTake': instance.toTake,
    };

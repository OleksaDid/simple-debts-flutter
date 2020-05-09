// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DebtList _$DebtListFromJson(Map<String, dynamic> json) {
  return DebtList(
    debts: (json['debts'] as List)
        ?.map(
            (e) => e == null ? null : Debt.fromJson(e as Map<String, dynamic>))
        ?.toList(),
    summary: json['summary'] == null
        ? null
        : DebtListSummary.fromJson(json['summary'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$DebtListToJson(DebtList instance) => <String, dynamic>{
      'debts': instance.debts?.map((e) => e?.toJson())?.toList(),
      'summary': instance.summary?.toJson(),
    };

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Debt _$DebtFromJson(Map<String, dynamic> json) {
  return Debt(
    id: json['id'] as String,
    user: json['user'] == null
        ? null
        : User.fromJson(json['user'] as Map<String, dynamic>),
    type: _$enumDecodeNullable(_$DebtAccountTypeEnumMap, json['type']),
    currency: json['currency'] as String,
    status: _$enumDecodeNullable(_$DebtStatusEnumMap, json['status']),
    statusAcceptor: json['statusAcceptor'] as String,
    summary: (json['summary'] as num)?.toDouble(),
    moneyReceiver: json['moneyReceiver'] as String,
    moneyOperations: (json['moneyOperations'] as List)
        ?.map((e) =>
            e == null ? null : Operation.fromJson(e as Map<String, dynamic>))
        ?.toList(),
  );
}

Map<String, dynamic> _$DebtToJson(Debt instance) => <String, dynamic>{
      'id': instance.id,
      'user': instance.user?.toJson(),
      'type': _$DebtAccountTypeEnumMap[instance.type],
      'currency': instance.currency,
      'status': _$DebtStatusEnumMap[instance.status],
      'statusAcceptor': instance.statusAcceptor,
      'summary': instance.summary,
      'moneyReceiver': instance.moneyReceiver,
      'moneyOperations':
          instance.moneyOperations?.map((e) => e?.toJson())?.toList(),
    };

T _$enumDecode<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    throw ArgumentError('A value must be provided. Supported values: '
        '${enumValues.values.join(', ')}');
  }

  final value = enumValues.entries
      .singleWhere((e) => e.value == source, orElse: () => null)
      ?.key;

  if (value == null && unknownValue == null) {
    throw ArgumentError('`$source` is not one of the supported values: '
        '${enumValues.values.join(', ')}');
  }
  return value ?? unknownValue;
}

T _$enumDecodeNullable<T>(
  Map<T, dynamic> enumValues,
  dynamic source, {
  T unknownValue,
}) {
  if (source == null) {
    return null;
  }
  return _$enumDecode<T>(enumValues, source, unknownValue: unknownValue);
}

const _$DebtAccountTypeEnumMap = {
  DebtAccountType.SINGLE_USER: 'SINGLE_USER',
  DebtAccountType.MULTIPLE_USERS: 'MULTIPLE_USERS',
};

const _$DebtStatusEnumMap = {
  DebtStatus.CREATION_AWAITING: 'CREATION_AWAITING',
  DebtStatus.UNCHANGED: 'UNCHANGED',
  DebtStatus.CHANGE_AWAITING: 'CHANGE_AWAITING',
  DebtStatus.USER_DELETED: 'USER_DELETED',
  DebtStatus.CONNECT_USER: 'CONNECT_USER',
};

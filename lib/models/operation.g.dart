// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'operation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Operation _$OperationFromJson(Map<String, dynamic> json) {
  return Operation(
    id: json['id'] as String,
    date: json['date'] == null ? null : DateTime.parse(json['date'] as String),
    status: _$enumDecodeNullable(_$OperationStatusEnumMap, json['status']),
    statusAcceptor: json['statusAcceptor'] as String,
    moneyAmount: (json['moneyAmount'] as num)?.toDouble(),
    moneyReceiver: json['moneyReceiver'] as String,
    description: json['description'] as String,
    cancelledBy: json['cancelledBy'] as String,
  );
}

Map<String, dynamic> _$OperationToJson(Operation instance) => <String, dynamic>{
      'id': instance.id,
      'date': instance.date?.toIso8601String(),
      'status': _$OperationStatusEnumMap[instance.status],
      'statusAcceptor': instance.statusAcceptor,
      'moneyAmount': instance.moneyAmount,
      'moneyReceiver': instance.moneyReceiver,
      'description': instance.description,
      'cancelledBy': instance.cancelledBy,
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

const _$OperationStatusEnumMap = {
  OperationStatus.CREATION_AWAITING: 'CREATION_AWAITING',
  OperationStatus.UNCHANGED: 'UNCHANGED',
  OperationStatus.CANCELLED: 'CANCELLED',
};

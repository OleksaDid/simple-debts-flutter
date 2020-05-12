import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';

part 'operation.g.dart';

enum OperationStatus {
  CREATION_AWAITING,
  UNCHANGED,
  CANCELLED
}

@JsonSerializable()
class Operation {
  final String id;
  final DateTime date;
  final OperationStatus status;
  final String statusAcceptor;
  final double moneyAmount;
  final String moneyReceiver;
  final String description;
  final String cancelledBy;

  const Operation({
    @required this.id,
    @required this.date,
    @required this.status,
    @required this.statusAcceptor,
    @required this.moneyAmount,
    @required this.moneyReceiver,
    @required this.description,
    @required this.cancelledBy
  });

  factory Operation.fromJson(Map<String, dynamic> json) => _$OperationFromJson(json);
  Map<String, dynamic> toJson() => _$OperationToJson(this);
}
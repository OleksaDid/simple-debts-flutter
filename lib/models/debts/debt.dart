import 'package:flutter/material.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:simpledebts/models/debts/operation.dart';
import 'package:simpledebts/models/user/user.dart';

part 'debt.g.dart';

enum DebtAccountType {
  SINGLE_USER,
  MULTIPLE_USERS
}

enum DebtStatus {
  CREATION_AWAITING,
  UNCHANGED,
  CHANGE_AWAITING,
  USER_DELETED,
  CONNECT_USER
}

@JsonSerializable(explicitToJson: true)
class Debt with ChangeNotifier {
  final String id;
  final User user;
  final DebtAccountType type;
  final String currency;
  final DebtStatus status;
  final String statusAcceptor;
  final double summary;
  final String moneyReceiver;
  final List<Operation> moneyOperations;

  Debt({
    @required this.id,
    @required this.user,
    @required this.type,
    @required this.currency,
    @required this.status,
    @required this.statusAcceptor,
    @required this.summary,
    @required this.moneyReceiver,
    @required this.moneyOperations
  });

  factory Debt.fromJson(Map<String, dynamic> json) => _$DebtFromJson(json);
  Map<String, dynamic> toJson() => _$DebtToJson(this);

  bool get hasNotification {
    return statusAcceptor != null && statusAcceptor != user.id;
  }

  bool get youReceiveMoney {
    return moneyReceiver != null && moneyReceiver != user.id;
  }

  Color getSummaryColor(BuildContext context) {
    if(summary == 0) {
      return Theme.of(context).textTheme.headline6.color;
    } else {
      return youReceiveMoney
          ? Theme.of(context).colorScheme.primary
          : Theme.of(context).colorScheme.secondary;
    }
  }

  void addOperation(Operation operation) {
    moneyOperations.insert(0, operation);
    notifyListeners();
  }

  Map<int, Operation> removeOperation(String id) {
    final operationIndex = moneyOperations.indexWhere((operation) => operation.id == id);
    final operation = moneyOperations[operationIndex];
    moneyOperations.removeAt(operationIndex);
    notifyListeners();
    return {
      operationIndex: operation
    };
  }

  void restoreOperation(Map<int, Operation> operationData) {
    moneyOperations[operationData.keys.elementAt(0)] = operationData.values.elementAt(0);
    notifyListeners();
  }

  void updateOperation(String id, Operation operation) {
    final operationIndex = moneyOperations.indexWhere((operation) => operation.id == id);
    moneyOperations[operationIndex] = operation;
    notifyListeners();
  }
}
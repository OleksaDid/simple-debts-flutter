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

enum MoneyReceiveStatus {
  None,
  YouTake,
  YouGive
}

@JsonSerializable(explicitToJson: true)
class Debt {
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

  MoneyReceiveStatus get moneyReceiveStatus {
    return moneyReceiver == null
        ? MoneyReceiveStatus.None
        : moneyReceiver == user.id
          ? MoneyReceiveStatus.YouGive
          : MoneyReceiveStatus.YouTake;
  }

  Color getSummaryColor(BuildContext context) {
    Map<MoneyReceiveStatus, Color> moneyReceiveColors = {
      MoneyReceiveStatus.None: Theme.of(context).textTheme.headline6.color,
      MoneyReceiveStatus.YouTake: Theme.of(context).colorScheme.secondary,
      MoneyReceiveStatus.YouGive: Theme.of(context).colorScheme.primary,
    };

    return moneyReceiveColors[moneyReceiveStatus];
  }

  String getTitleText(User user) {
    final Map<MoneyReceiveStatus, String> titles = {
      MoneyReceiveStatus.None: '${user.name} \n owes you nothing',
      MoneyReceiveStatus.YouTake: 'You owe ${user.name} \n ${summary.toStringAsFixed(2)} $currency',
      MoneyReceiveStatus.YouGive: '${user.name} owes you \n ${summary.toStringAsFixed(2)} $currency',
    };

    return titles[moneyReceiveStatus];
  }
  
  bool get isUserConnectAllowed {
    return type == DebtAccountType.SINGLE_USER && status != DebtStatus.CONNECT_USER && status != DebtStatus.USER_DELETED;
  }

  bool get hasUnacceptedOperations {
    return moneyOperations != null
        ? moneyOperations.any((operation) => operation.status == OperationStatus.CREATION_AWAITING &&
          operation.statusAcceptor != user.id)
        : false;
  }
}
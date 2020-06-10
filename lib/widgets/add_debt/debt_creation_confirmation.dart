import 'package:flutter/material.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/widgets/common/currency_select/currency_select.dart';

class DebtCreationConfirmation extends StatelessWidget {
  final String userName;
  final User user;
  final String currency;
  final void Function() onCancel;
  final void Function(String currency) onCurrencySelect;
  final Future<void> Function() onSubmit;

  DebtCreationConfirmation({
    @required this.userName,
    @required this.user,
    @required this.currency,
    @required this.onCancel,
    @required this.onCurrencySelect,
    @required this.onSubmit
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Create debt with $userName?',
            style: TextStyle(
              fontSize: 20
            ),
          ),
          SizedBox(height: 30,),
          if(user != null) CircleAvatar(
            backgroundImage: NetworkImage(user.picture),
            radius: 50,
          ),
          if(user == null) CircleAvatar(
            radius: 50,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'virtual user',
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          SizedBox(height: 30,),
          CurrencySelect(
            defaultCurrency: currency,
            onSelect: onCurrencySelect,
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlatButton(
                child: Text('NO'),
                textColor: Theme.of(context).primaryColor,
                onPressed: onCancel,
              ),
              FlatButton(
                child: Text('YES'),
                textColor: Theme.of(context).primaryColor,
                onPressed: onSubmit,
              ),
            ],
          )
        ],
      ),
    );
  }
}
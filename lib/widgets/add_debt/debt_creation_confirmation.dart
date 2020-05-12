import 'package:flutter/material.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/widgets/add_debt/currency_select.dart';

class DebtCreationConfirmation extends StatefulWidget {
  final String userName;
  final User user;
  final void Function() onCancel;
  final Future<void> Function(String currency) onSubmit;

  DebtCreationConfirmation({
    this.userName,
    this.user,
    this.onCancel,
    this.onSubmit
  });

  @override
  _DebtCreationConfirmationState createState() => _DebtCreationConfirmationState();
}

class _DebtCreationConfirmationState extends State<DebtCreationConfirmation> {
  String _currency = 'UAH';

  void _setCurrency(String currency) {
    setState(() => _currency = currency);
  }

  void _submit() {
    widget.onSubmit(_currency);
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Create debt with ${widget.userName}?',
            style: TextStyle(
              fontSize: 20
            ),
          ),
          SizedBox(height: 30,),
          if(widget.user != null) CircleAvatar(
            backgroundImage: NetworkImage(widget.user.picture),
            radius: 50,
          ),
          if(widget.user == null) CircleAvatar(
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
            defaultCurrency: _currency,
            onSelect: _setCurrency,
          ),
          SizedBox(height: 20,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FlatButton(
                child: Text('NO'),
                onPressed: widget.onCancel,
              ),
              FlatButton(
                child: Text('YES'),
                onPressed: _submit,
              ),
            ],
          )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';

class AddVirtualUserDebtForm extends StatefulWidget {
  final void Function(String name) onNameSelect;

  AddVirtualUserDebtForm({
    @required this.onNameSelect
  });

  @override
  _AddVirtualUserDebtFormState createState() => _AddVirtualUserDebtFormState();
}

class _AddVirtualUserDebtFormState extends State<AddVirtualUserDebtForm> {
  final _form = GlobalKey<FormState>();
  String _name = '';

  String _nameValidator(String value) {
    if(value.isEmpty || value.length < 3) {
      return 'Minimum 3 characters';
    }
    return null;
  }

  Future<void> _chooseName() async {
    final isValid = _form.currentState.validate();
    if(isValid) {
      _form.currentState.save();
      widget.onNameSelect(_name);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(
              hintText: 'Virtual user name',
              helperText: 'You can create debt with vurtual user'
            ),
            onSaved: (value) => _name = value,
            validator: _nameValidator,
          ),
          FlatButton(
            child: Text('CREATE DEBT'),
            textColor: Theme.of(context).primaryColor,
            onPressed: _chooseName,
          )
        ],
      ),
    );
  }
}
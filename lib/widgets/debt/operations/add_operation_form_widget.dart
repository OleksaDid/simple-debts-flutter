import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/spinner_store_use.dart';
import 'package:simpledebts/models/common/errors/failure.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/services/operations_service.dart';
import 'package:simpledebts/store/debt.store.dart';
import 'package:simpledebts/widgets/common/button_spinner.dart';

class AddOperationFormWidget extends StatefulWidget {
  final Debt debt;
  final String moneyReceiver;

  AddOperationFormWidget({
    @required this.debt,
    @required this.moneyReceiver,
  });

  @override
  _AddOperationFormWidgetState createState() => _AddOperationFormWidgetState();
}

class _AddOperationFormWidgetState extends State<AddOperationFormWidget> with SpinnerStoreUse {
  final _form = GlobalKey<FormState>();
  final FocusNode _descriptionFocusNode = FocusNode();
  String _description = '';
  String _moneyAmount = '';

  @override
  void dispose() {
    _descriptionFocusNode.dispose();
    super.dispose();
  }

  String get titleText {
    return widget.debt.user.id == widget.moneyReceiver
        ? 'Give money to ${widget.debt.user.name}'
        : 'Take money from ${widget.debt.user.name}';
  }

  String _descriptionValidator(String value) {
    if(value == null || value.length < 3) {
      return 'Minimum 3 symbols';
    }
    if(value.length > 70) {
      return 'Maximum 70 symbols';
    }
    return null;
  }

  String _moneyAmountValidator(String value) {
    if(value == null || value.isEmpty) {
      return 'Should not be empty';
    }
    if(double.tryParse(value) == null) {
      return 'Should be a valid number';
    }
    if(double.parse(value).isNegative || double.parse(value) == 0) {
      return 'Should be a positive number';
    }
    return null;
  }

  Future<void> _submitForm() async {
    final isValid = _form.currentState.validate();
    if(!isValid) {
      return;
    }
    _form.currentState.save();

    showSpinner();
    try {
      FocusScope.of(context).unfocus();
      await GetIt.instance<DebtStore>().addOperation(
          description: _description,
          moneyReceiver: widget.moneyReceiver,
          moneyAmount: double.parse(_moneyAmount)
      );
      Navigator.of(context).pop();
    } on Failure catch(error) {
      ErrorHelper.showErrorDialog(context, error.message);
    }
    hideSpinner();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _form,
      child: Container(
        constraints: BoxConstraints(
          maxHeight: 320
        ),
        child: Stack(
          children: [
            Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  titleText,
                  style: TextStyle(
                      fontSize: 20
                  ),
                ),
                SizedBox(height: 20,),
                TextFormField(
                  keyboardType: TextInputType.numberWithOptions(decimal: true),
                  decoration: InputDecoration(
                    hintText: 'money amount (${widget.debt.currency})',
                  ),
                  validator: _moneyAmountValidator,
                  textInputAction: TextInputAction.next,
                  onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_descriptionFocusNode),
                  onSaved: (value) => _moneyAmount = value,
                ),
                SizedBox(height: 10,),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: 'description',
                  ),
                  validator: _descriptionValidator,
                  focusNode: _descriptionFocusNode,
                  maxLength: 70,
                  maxLengthEnforced: true,
                  onSaved: (value) => _description = value.trim(),
                ),
                SizedBox(height: 20,),
                spinnerContainer(
                  spinner: ButtonSpinner(),
                  replacement: FlatButton(
                    child: Text('ADD'),
                    textColor: Theme.of(context).primaryColor,
                    onPressed: _submitForm,
                  ),
                )
              ],
            ),
          ],
        ),
      )
    );
  }
}
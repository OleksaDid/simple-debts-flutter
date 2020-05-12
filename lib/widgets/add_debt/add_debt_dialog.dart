import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/providers/debts_provider.dart';
import 'package:simpledebts/screens/debt_screen.dart';
import 'package:simpledebts/widgets/add_debt/add_virtual_user_debt_form.dart';
import 'package:simpledebts/widgets/add_debt/debt_creation_confirmation.dart';
import 'package:simpledebts/widgets/add_debt/users_search.dart';

enum FormStep {
  Initial,
  UsersSearch,
  Confirmation,
  Creation
}

class AddDebtDialog extends StatefulWidget {

  @override
  _AddDebtDialogState createState() => _AddDebtDialogState();
}

class _AddDebtDialogState extends State<AddDebtDialog> {
  FormStep _formStep = FormStep.Initial;
  String _virtualUserName = '';
  User _selectedUser;
  
  void _setUsersSearch() {
    setState(() => _formStep = FormStep.UsersSearch);
  }
  
  void _setInitialStep() {
    setState(() {
      _virtualUserName = '';
      _selectedUser = null;
      _formStep = FormStep.Initial;
    });
  }

  void _setRegisteredUser(User user) {
    FocusScope.of(context).unfocus();
    setState(() {
      _selectedUser = user;
      _formStep = FormStep.Confirmation;
    });
  }

  void _setVirtualUserName(String name) {
    FocusScope.of(context).unfocus();
    setState(() {
      _virtualUserName = name;
      _formStep = FormStep.Confirmation;
    });
  }

  void _cancelConfirmation() {
    if(_virtualUserName != null) {
      _setInitialStep();
    } else {
      _setUsersSearch();
    }
  }

  void _setCreationStep() {
    setState(() => _formStep = FormStep.Creation);
  }

  Future<void> _createDebt(String currency) async {
    _setCreationStep();
    try {
      final debtProvider = Provider.of<DebtsProvider>(context, listen: false);
      String debtId;
      if(_virtualUserName != null && _virtualUserName.isNotEmpty) {
        debtId = await debtProvider.createSingleDebt(_virtualUserName, currency);
      } else {
        debtId = await debtProvider.createMultipleDebt(_selectedUser.id, currency);
      }
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(DebtScreen.routeName, arguments: {
        'id': debtId
      });
    } catch(error) {
      ErrorHelper.handleError(error);
    }
  }

  Widget _buildStep() {
    switch(_formStep) {
      case FormStep.Initial: {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Create a debt',
              style: TextStyle(
                fontSize: 20
              ),
            ),
            SizedBox(height: 20,),
            AddVirtualUserDebtForm(
              onNameSelect: _setVirtualUserName,
            ),
            Divider(),
            FlatButton(
              child: Text('SEARCH REGISTERED USERS'),
              onPressed: _setUsersSearch,
              textColor: Theme.of(context).primaryColor,
            )
          ],
        );
      }
      break;

      case FormStep.UsersSearch: {
        return UsersSearch(
          onSelectUser: _setRegisteredUser,
          onCancel: _setInitialStep,
        );
      }
      break;

      case FormStep.Confirmation: {
        return DebtCreationConfirmation(
          userName: _virtualUserName.isNotEmpty ? _virtualUserName : _selectedUser.name,
          user: _selectedUser,
          onCancel: _cancelConfirmation,
          onSubmit: _createDebt,
        );
      }
      break;

      case FormStep.Creation: {
        return Container(
          height: 80,
          child: Center(
            child: CircularProgressIndicator(),
          ),
        );
      }
      break;
    }
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12)
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          vertical: 30.0,
          horizontal: 40.0,
        ),
        child: _buildStep(),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/helpers/dialog_helper.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/models/common/errors/failure.dart';
import 'package:simpledebts/models/common/route/id_route_argument.dart';
import 'package:simpledebts/models/debts/debt.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/screens/debt_screen.dart';
import 'package:simpledebts/store/debt_list.store.dart';
import 'package:simpledebts/widgets/add_debt/add_virtual_user_debt_form.dart';
import 'package:simpledebts/widgets/add_debt/debt_creation_confirmation.dart';
import 'package:simpledebts/widgets/common/user_search/users_search.dart';

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
      final debtProvider = GetIt.instance<DebtListStore>();
      Debt debt;
      if(_virtualUserName != null && _virtualUserName.isNotEmpty) {
        debt = await debtProvider.createSingleDebt(_virtualUserName, currency);
      } else {
        debt = await debtProvider.createMultipleDebt(_selectedUser.id, currency);
      }
      Navigator.of(context).pop();
      Navigator.of(context).pushNamed(DebtScreen.routeName, arguments: IdRouteArgument(debt.id));
    } on Failure catch(error) {
      ErrorHelper.showErrorDialog(context, error.message);
      _setInitialStep();
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
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Find user',
              style: TextStyle(
                  fontSize: 20
              ),
            ),
            UsersSearch(
              onSelectUser: _setRegisteredUser,
              onCancel: _setInitialStep,
            ),
          ],
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

    return DialogHelper.getThemedDialog(
      child: _buildStep(),
    );
  }
}
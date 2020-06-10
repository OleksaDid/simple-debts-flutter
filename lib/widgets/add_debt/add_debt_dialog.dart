import 'package:flutter/material.dart';
import 'package:simpledebts/helpers/dialog_helper.dart';
import 'package:simpledebts/widgets/add_debt/add_debt.store.dart';
import 'package:simpledebts/widgets/add_debt/add_virtual_user_debt_form.dart';
import 'package:simpledebts/widgets/add_debt/debt_creation_confirmation.dart';
import 'package:simpledebts/widgets/common/user_search/users_search.dart';


class AddDebtDialog extends StatelessWidget {
  final AddDebtStore _addDebtStore = AddDebtStore();

  Widget _buildInitialStep(BuildContext context) => Column(
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
          onNameSelect: (name) => _addDebtStore.setVirtualUserName(context, name),
        ),
        Divider(),
        FlatButton(
          child: Text('SEARCH REGISTERED USERS'),
          onPressed: _addDebtStore.setUsersSearchStep,
          textColor: Theme.of(context).primaryColor,
        )
      ],
    );

  Widget _buildUsersSearchStep(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      Text(
        'Find user',
        style: TextStyle(
            fontSize: 20
        ),
      ),
      UsersSearch(
        onSelectUser: (user) => _addDebtStore.setRegisteredUser(context, user),
        onCancel: _addDebtStore.setInitialStep,
      ),
    ],
  );

  Widget _buildConfirmationStep(BuildContext context) => DebtCreationConfirmation(
    userName: _addDebtStore.virtualUserName.isNotEmpty
        ? _addDebtStore.virtualUserName
        : _addDebtStore.selectedUser.name,
    user: _addDebtStore.selectedUser,
    currency: _addDebtStore.currency,
    onCurrencySelect: _addDebtStore.setCurrency,
    onCancel: _addDebtStore.cancelConfirmation,
    onSubmit: () => _addDebtStore.createDebt(context),
  );

  Widget _buildCreationStep() => Container(
    height: 80,
    child: Center(
      child: CircularProgressIndicator(),
    ),
  );

  @override
  Widget build(BuildContext context) {

    return DialogHelper.getThemedDialog(
      child: StreamBuilder<FormStep>(
        stream: _addDebtStore.currentStep$,
        builder: (context, snapshot) {
          if(snapshot.connectionState == ConnectionState.waiting) {
            return SizedBox();
          }

          switch(snapshot.data) {
            case FormStep.Initial: return _buildInitialStep(context);
            case FormStep.UsersSearch: return _buildUsersSearchStep(context);
            case FormStep.Confirmation: return _buildConfirmationStep(context);
            case FormStep.Creation: return _buildCreationStep();
            default: return SizedBox();
          }
        },
      ),
    );
  }
}
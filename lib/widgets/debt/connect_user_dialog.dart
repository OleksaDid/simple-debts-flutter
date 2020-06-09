import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/helpers/dialog_helper.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/spinner_store_use.dart';
import 'package:simpledebts/models/common/errors/failure.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/store/debt.store.dart';
import 'package:simpledebts/widgets/common/button_spinner.dart';
import 'package:simpledebts/widgets/common/user_search/users_search.dart';

class ConnectUserDialog extends StatefulWidget {

  @override
  _ConnectUserDialogState createState() => _ConnectUserDialogState();
}

class _ConnectUserDialogState extends State<ConnectUserDialog> with SpinnerStoreUse {
  User _selectedUser;

  Future<void> _connectUser() async {
    showSpinner();
    try {
      await GetIt.instance<DebtStore>().connectUserToSingleDebt(_selectedUser.id);
      Navigator.of(context).pop();
    } on Failure catch(error) {
      ErrorHelper.showErrorDialog(context, error.message);
    }
    hideSpinner();
  }

  void _selectUser(User user) {
    setState(() => _selectedUser = user);
  }

  void _resetUser() {
    setState(() => _selectedUser = null);
  }

  void _closeModal() {
    Navigator.of(context).pop();
  }


  @override
  Widget build(BuildContext context) {
    return DialogHelper.getThemedDialog(
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if(_selectedUser == null) Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('Find user', style: Theme.of(context).textTheme.headline6,),
                SizedBox(height: 6,),
                Text(
                  'You can change virtual user with real one',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
                UsersSearch(
                  onSelectUser: _selectUser,
                  onCancel: _closeModal,
                ),
              ],
            ),
            if(_selectedUser != null) Column(
              children: [
                Text('Add this user?', style: Theme.of(context).textTheme.headline6,),
                SizedBox(height: 25,),
                CircleAvatar(
                  radius: 38,
                  backgroundImage: NetworkImage(_selectedUser.picture),
                  backgroundColor: Colors.white
                ),
                SizedBox(height: 4,),
                Text(
                  _selectedUser.name,
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 16,),
                spinnerContainer(
                  spinner: ButtonSpinner(radius: 30,),
                  replacement: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      FlatButton(
                        child: Text('CHANGE'),
                        textColor: Theme.of(context).primaryColor,
                        onPressed: _resetUser,
                      ),
                      FlatButton(
                        child: Text('ADD'),
                        textColor: Theme.of(context).primaryColor,
                        onPressed: _connectUser,
                      ),
                    ],
                  )
                )
              ],
            )
          ],
        ),
      )
    );
  }
}
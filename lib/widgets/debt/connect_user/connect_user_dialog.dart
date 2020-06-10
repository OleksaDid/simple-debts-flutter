import 'package:flutter/material.dart';
import 'package:simpledebts/helpers/dialog_helper.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/widgets/common/button_spinner.dart';
import 'package:simpledebts/widgets/common/user_search/users_search.dart';
import 'package:simpledebts/widgets/debt/connect_user/connect_user.store.dart';

class ConnectUserDialog extends StatelessWidget {
  final ConnectUserStore _connectUserStore = ConnectUserStore();

  @override
  Widget build(BuildContext context) {
    return DialogHelper.getThemedDialog(
      child: SingleChildScrollView(
        child: StreamBuilder<User>(
          stream: _connectUserStore.selectedUser$,
          builder: (context, snapshot) {
            if(snapshot.connectionState == ConnectionState.waiting) {
              return SizedBox();
            }

            final User selectedUser = snapshot.data;
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if(selectedUser == null) Column(
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
                      onSelectUser: _connectUserStore.selectUser,
                      onCancel: Navigator.of(context).pop,
                    ),
                  ],
                ),
                if(selectedUser != null) Column(
                  children: [
                    Text('Add this user?', style: Theme.of(context).textTheme.headline6,),
                    SizedBox(height: 25,),
                    CircleAvatar(
                        radius: 38,
                        backgroundImage: NetworkImage(selectedUser.picture),
                        backgroundColor: Colors.white
                    ),
                    SizedBox(height: 4,),
                    Text(
                      selectedUser.name,
                      style: TextStyle(fontSize: 20),
                    ),
                    SizedBox(height: 16,),
                    _connectUserStore.spinnerContainer(
                        spinner: ButtonSpinner(radius: 30,),
                        replacement: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FlatButton(
                              child: Text('CHANGE'),
                              textColor: Theme.of(context).primaryColor,
                              onPressed: _connectUserStore.resetUser,
                            ),
                            FlatButton(
                              child: Text('ADD'),
                              textColor: Theme.of(context).primaryColor,
                              onPressed: () => _connectUserStore.connectUser(context),
                            ),
                          ],
                        )
                    )
                  ],
                )
              ],
            );
          }
        ),
      )
    );
  }
}
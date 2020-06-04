import 'dart:async';

import 'package:flutter/material.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/spinner_store_use.dart';
import 'package:simpledebts/models/common/errors/failure.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/widgets/common/user_search/user_search.store.dart';
import 'package:simpledebts/widgets/common/debounce_input.dart';

class UsersSearch extends StatelessWidget with SpinnerStoreUse {
  final _usersStore = UserSearchStore();

  final void Function(User user) onSelectUser;
  final void Function() onCancel;

  UsersSearch({
    @required this.onSelectUser,
    @required this.onCancel,
  });

  Future<void> _getUsersList(BuildContext context, String name) async {
    showSpinner();
    try {
      await _usersStore.getUsers(name);
    } on Failure catch(error) {
      ErrorHelper.showErrorDialog(context, error.message);
    }
    hideSpinner();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 360,
      ),
      child: Column(
        children: [
          SizedBox(height: 20,),
          DebounceInput(
            inputDecoration: InputDecoration(
              hintText: 'type user name',
            ),
            onInputChange: (name) => _getUsersList(context, name),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: Stack(
              children: [
                StreamBuilder<List<User>>(
                  stream: _usersStore.users$,
                  builder: (context, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else {
                      final users = snapshot.data;

                      return ListView.builder(
                        itemCount: users.length,
                        itemBuilder: (context, index) => InkWell(
                          onTap: () => onSelectUser(users[index]),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundImage: NetworkImage(users[index].picture),
                            ),
                            title: Text(users[index].name),
                          ),
                        ),
                      );
                    }
                  },
                ),
                spinnerContainer(
                  spinner: Container(
                    height: double.infinity,
                    width: double.infinity,
                    color: Colors.white54,
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                )
              ],
            ),
          ),
          FlatButton(
            child: Text('BACK'),
            onPressed: onCancel,
            textColor: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
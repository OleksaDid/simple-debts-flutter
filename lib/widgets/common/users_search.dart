import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/spinner_store_use.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/store/user_search_store.dart';
import 'package:simpledebts/widgets/common/debounce_input.dart';

class UsersSearch extends StatelessWidget with SpinnerStoreUse {
  final _usersStore = UserSearchStore();

  final void Function(User user) onSelectUser;
  final void Function() onCancel;

  UsersSearch({
    @required this.onSelectUser,
    @required this.onCancel,
  });

  Future<void> _getUsersList(String name) async {
    showSpinner();
    try {
      await _usersStore.getUsers(name);
    } catch(error) {
      // TODO: log error
      ErrorHelper.handleError(error);
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
            onInputChange: _getUsersList,
          ),
          SizedBox(height: 10,),
          Expanded(
            child: Stack(
              children: [
                Observer(
                  builder: (_) => ListView.builder(
                    itemCount: _usersStore.userList.length,
                    itemBuilder: (context, index) => InkWell(
                      onTap: () => onSelectUser(_usersStore.userList[index]),
                      child: ListTile(
                        leading: CircleAvatar(
                          backgroundImage: NetworkImage(_usersStore.userList[index].picture),
                        ),
                        title: Text(_usersStore.userList[index].name),
                      ),
                    ),
                  ),
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
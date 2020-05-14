import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/spinner_state.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/providers/users_provider.dart';

class UsersSearch extends StatefulWidget {
  final void Function(User user) onSelectUser;
  final void Function() onCancel;

  UsersSearch({
    @required this.onSelectUser,
    @required this.onCancel,
  });

  @override
  _UsersSearchState createState() => _UsersSearchState();
}

class _UsersSearchState extends State<UsersSearch> with SpinnerState {
  final _searchQuery = TextEditingController();
  Timer _debounce;
  List<User> _usersList = [];

  _onSearchChanged() {
    if (_debounce?.isActive ?? false) _debounce.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () => _getUsersList());
  }

  Future<void> _getUsersList() async {
    if(_searchQuery.text == null || _searchQuery.text.isEmpty) {
      return;
    }
    showSpinner();
    try {
      final users = await Provider.of<UsersProvider>(context, listen: false).getUsers(_searchQuery.text);
      setState(() =>_usersList = users);
    } catch(error) {
      ErrorHelper.showErrorSnackBar(context);
    }
    hideSpinner();
  }

  @override
  void initState() {
    super.initState();
    _searchQuery.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchQuery.removeListener(_onSearchChanged);
    _searchQuery.dispose();
    _debounce.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(
        maxHeight: 360,
      ),
      child: Column(
        children: [
          Text(
            'Find user',
            style: TextStyle(
              fontSize: 20
            ),
          ),
          SizedBox(height: 20,),
          TextField(
            controller: _searchQuery,
            decoration: InputDecoration(
              hintText: 'type user name',
            ),
          ),
          SizedBox(height: 10,),
          Expanded(
            child: Stack(
              children: [
                ListView.builder(
                  itemCount: _usersList.length,
                  itemBuilder: (context, index) => InkWell(
                    onTap: () => widget.onSelectUser(_usersList[index]),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundImage: NetworkImage(_usersList[index].picture),
                      ),
                      title: Text(_usersList[index].name),
                    ),
                  ),
                ),
                if(spinnerVisible) Container(
                  height: double.infinity,
                  width: double.infinity,
                  color: Colors.white54,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                )
              ],
            ),
          ),
          FlatButton(
            child: Text('BACK'),
            onPressed: widget.onCancel,
            textColor: Theme.of(context).primaryColor,
          )
        ],
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simpledebts/helpers/error_helper.dart';
import 'package:simpledebts/mixins/spinner_store_use.dart';
import 'package:simpledebts/models/common/errors/failure.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/services/users_service.dart';

class UserSearchStore with SpinnerStoreUse {
  final _usersService = GetIt.instance<UsersService>();

  final BehaviorSubject<List<User>> _userList = BehaviorSubject.seeded([]);

  Stream<List<User>> get users$ => _userList.stream;

  Future<void> _getUsers(String name) async {
    if(name == null || name.isEmpty) {
      _userList.add([]);
    } else {
      final users = await _usersService.getUsers(name);
      _userList.add(users);
    }
  }

  Future<void> getUsersList(BuildContext context, String name) async {
    showSpinner();
    try {
      await _getUsers(name);
    } on Failure catch(error) {
      ErrorHelper.showErrorDialog(context, error.message);
    }
    hideSpinner();
  }
}
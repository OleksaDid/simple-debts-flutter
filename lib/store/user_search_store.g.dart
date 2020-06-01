// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_search_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$UserSearchStore on _UserSearchStore, Store {
  final _$userListAtom = Atom(name: '_UserSearchStore.userList');

  @override
  ObservableList<User> get userList {
    _$userListAtom.reportRead();
    return super.userList;
  }

  @override
  set userList(ObservableList<User> value) {
    _$userListAtom.reportWrite(value, super.userList, () {
      super.userList = value;
    });
  }

  final _$getUsersAsyncAction = AsyncAction('_UserSearchStore.getUsers');

  @override
  Future<void> getUsers(String name) {
    return _$getUsersAsyncAction.run(() => super.getUsers(name));
  }

  @override
  String toString() {
    return '''
userList: ${userList}
    ''';
  }
}

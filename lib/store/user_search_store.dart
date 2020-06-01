import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/services/users_service.dart';

part 'user_search_store.g.dart';

class UserSearchStore = _UserSearchStore with _$UserSearchStore;

abstract class _UserSearchStore with Store {
  final _usersService = GetIt.instance<UsersService>();

  @observable
  var userList = ObservableList<User>();

  @action
  Future<void> getUsers(String name) async {
    if(name == null || name.isEmpty) {
      userList.clear();
    } else {
      final users = await _usersService.getUsers(name);
      userList.clear();
      userList.addAll(users);
    }
  }
}
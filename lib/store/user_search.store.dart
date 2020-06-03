import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/services/users_service.dart';

class UserSearchStore {
  final _usersService = GetIt.instance<UsersService>();

  final BehaviorSubject<List<User>> _userList = BehaviorSubject.seeded([]);

  Stream<List<User>> get users$ => _userList.stream;

  Future<void> getUsers(String name) async {
    if(name == null || name.isEmpty) {
      _userList.add([]);
    } else {
      final users = await _usersService.getUsers(name);
      _userList.add(users);
    }
  }
}
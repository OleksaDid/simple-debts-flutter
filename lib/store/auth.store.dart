import 'package:get_it/get_it.dart';
import 'package:rxdart/rxdart.dart';
import 'package:simpledebts/helpers/shared_preferences_helper.dart';
import 'package:simpledebts/models/auth/auth_data.dart';
import 'package:simpledebts/models/auth/auth_form.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/services/auth_service.dart';

class AuthStore {

  final AuthService _authService = GetIt.instance<AuthService>();

  final BehaviorSubject<AuthData> _authData = BehaviorSubject();
  final BehaviorSubject<bool> _logout = BehaviorSubject.seeded(false);


  Stream<AuthData> get authData$ => Stream
      .fromFuture(SharedPreferencesHelper.getAuthData().then((data) => _authData.add(data)))
      .flatMap((_) => _authData.stream);

  Stream<User> get currentUser$ => authData$.map((data) => data?.user);
  Stream<bool> get logout$ => _logout.stream.where((logout) => logout == true);

  AuthData get authData => _authData.value;
  User get currentUser => authData?.user;


  void updateUserData(User user) => _authData.add(AuthData(
      token: authData.token,
      refreshToken: authData.refreshToken,
      user: user
  ));

  void logout() => _updateData(null);

  Future<AuthData> autoLogin() => _authService
      .autoLogin()
      ..then((data) => _updateData(data));

  Future<AuthData> facebookLogin() => _authService
      .facebookLogin()
      ..then((data) => _updateData(data));

  Future<AuthData> login(AuthForm authForm) => _authService
      .login(authForm)
      ..then((data) => _updateData(data));

  Future<AuthData> signUp(AuthForm authForm) => _authService
      .signUp(authForm)
      ..then((data) => _updateData(data));

  Future<AuthData> refreshToken() => _authService
      .refreshToken(authData)
      ..then((data) => _updateData(data));


  bool checkIfAuthenticated(AuthData data) => data == null ? false : data.isAuthenticated;

  void _updateData(AuthData data) {
    if(data == null) {
      print('REMOVED');
      if(authData != null) {
        _logout.add(true);
        _logout.add(false);
      }
      SharedPreferencesHelper.removeAllData();
    } else {
      print('SAVED');
      SharedPreferencesHelper.saveAuthData(data);
    }
    _authData.add(data);
  }
}
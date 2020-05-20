import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:simpledebts/helpers/shared_preferences_helper.dart';
import 'package:simpledebts/models/auth/auth_data.dart';
import 'package:simpledebts/models/auth/auth_form.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/providers/auth_service.dart';

part 'auth_data_store.g.dart';

class AuthDataStore = _AuthDataStore with _$AuthDataStore;

abstract class _AuthDataStore with Store {

  AuthService _authService = GetIt.instance<AuthService>();

  @observable
  AuthData authData = AuthData.empty();

  @computed
  bool get isAuthenticated => authData == null ? false : authData.isAuthenticated;

  @computed
  User get currentUser => authData?.user;


  @action
  void updateAuthData(AuthData newAuthData) => authData = newAuthData;

  @action
  void updateUserData(User user) => authData = AuthData(
      token: authData.token,
      refreshToken: authData.refreshToken,
      user: user
    );

  @action
  void logout() => authData = null;

  @action
  Future<AuthData> autoLogin() => _authService.autoLogin().then((value) => authData = value);

  @action
  Future<AuthData> facebookLogin() => _authService.facebookLogin().then((value) => authData = value);

  @action
  Future<AuthData> login(AuthForm authForm) => _authService.login(authForm).then((value) => authData = value);

  @action
  Future<AuthData> signUp(AuthForm authForm) => _authService.signUp(authForm).then((value) => authData = value);

  @action
  Future<AuthData> refreshToken() => _authService.refreshToken(authData).then((value) => authData = value);
  
  @action
  Future<AuthData> initAuthData() => SharedPreferencesHelper.getAuthData().then((value) => authData = value);


  ReactionDisposer getSharedPreferencesDisposer() {
    return reaction((_) => authData, (data) {
      if(data == null) {
        print('REMOVED');
        SharedPreferencesHelper.removeAllData();
      } else {
        print('SAVED');
        SharedPreferencesHelper.saveAuthData(authData);
      }
    });
  }
}
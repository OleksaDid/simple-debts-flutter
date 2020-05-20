// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_data_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$AuthDataStore on _AuthDataStore, Store {
  Computed<bool> _$isAuthenticatedComputed;

  @override
  bool get isAuthenticated =>
      (_$isAuthenticatedComputed ??= Computed<bool>(() => super.isAuthenticated,
              name: '_AuthDataStore.isAuthenticated'))
          .value;
  Computed<User> _$currentUserComputed;

  @override
  User get currentUser =>
      (_$currentUserComputed ??= Computed<User>(() => super.currentUser,
              name: '_AuthDataStore.currentUser'))
          .value;

  final _$authDataAtom = Atom(name: '_AuthDataStore.authData');

  @override
  AuthData get authData {
    _$authDataAtom.reportRead();
    return super.authData;
  }

  @override
  set authData(AuthData value) {
    _$authDataAtom.reportWrite(value, super.authData, () {
      super.authData = value;
    });
  }

  final _$_AuthDataStoreActionController =
      ActionController(name: '_AuthDataStore');

  @override
  void updateAuthData(AuthData newAuthData) {
    final _$actionInfo = _$_AuthDataStoreActionController.startAction(
        name: '_AuthDataStore.updateAuthData');
    try {
      return super.updateAuthData(newAuthData);
    } finally {
      _$_AuthDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void updateUserData(User user) {
    final _$actionInfo = _$_AuthDataStoreActionController.startAction(
        name: '_AuthDataStore.updateUserData');
    try {
      return super.updateUserData(user);
    } finally {
      _$_AuthDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void logout() {
    final _$actionInfo = _$_AuthDataStoreActionController.startAction(
        name: '_AuthDataStore.logout');
    try {
      return super.logout();
    } finally {
      _$_AuthDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<AuthData> autoLogin() {
    final _$actionInfo = _$_AuthDataStoreActionController.startAction(
        name: '_AuthDataStore.autoLogin');
    try {
      return super.autoLogin();
    } finally {
      _$_AuthDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<AuthData> facebookLogin() {
    final _$actionInfo = _$_AuthDataStoreActionController.startAction(
        name: '_AuthDataStore.facebookLogin');
    try {
      return super.facebookLogin();
    } finally {
      _$_AuthDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<AuthData> login(AuthForm authForm) {
    final _$actionInfo = _$_AuthDataStoreActionController.startAction(
        name: '_AuthDataStore.login');
    try {
      return super.login(authForm);
    } finally {
      _$_AuthDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<AuthData> signUp(AuthForm authForm) {
    final _$actionInfo = _$_AuthDataStoreActionController.startAction(
        name: '_AuthDataStore.signUp');
    try {
      return super.signUp(authForm);
    } finally {
      _$_AuthDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<AuthData> refreshToken() {
    final _$actionInfo = _$_AuthDataStoreActionController.startAction(
        name: '_AuthDataStore.refreshToken');
    try {
      return super.refreshToken();
    } finally {
      _$_AuthDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  Future<AuthData> initAuthData() {
    final _$actionInfo = _$_AuthDataStoreActionController.startAction(
        name: '_AuthDataStore.initAuthData');
    try {
      return super.initAuthData();
    } finally {
      _$_AuthDataStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
authData: ${authData},
isAuthenticated: ${isAuthenticated},
currentUser: ${currentUser}
    ''';
  }
}

import 'package:dio/src/dio.dart';
import 'package:simpledebts/models/auth/auth_data.dart';
import 'package:simpledebts/models/auth/auth_form.dart';
import 'package:simpledebts/models/user/user.dart';
import 'package:simpledebts/services/analytics_service.dart';
import 'package:simpledebts/services/auth_service.dart';
import 'package:simpledebts/services/http_service.dart';

class AuthServiceMock implements AuthService {

  @override
  Future<AuthData> login(AuthForm authForm) => _authDataFuture;

  @override
  Future<AuthData> refreshToken(AuthData authData) => _authDataFuture;

  @override
  Future<AuthData> autoLogin() => _authDataFuture;

  @override
  Future<AuthData> facebookLogin() => _authDataFuture;

  @override
  Future<AuthData> signUp(AuthForm authForm) => _authDataFuture;


  String get _token => DateTime.now().toIso8601String();
  String get _id => DateTime.now().millisecondsSinceEpoch.toString();
  Future<AuthData> get _authDataFuture => Future.delayed(
      Duration(seconds: 1),
          () => AuthData(
          user: User(
              id: _id,
              name: 'testis',
              picture: 'https://images.com/testis.png'
          ),
          token: _token,
          refreshToken: _token
      )
  );


  @override
  // TODO: implement analyticsService
  AnalyticsService get analyticsService => throw UnimplementedError();

  @override
  // TODO: implement http
  Dio get http => throw UnimplementedError();

  @override
  // TODO: implement httpService
  HttpService get httpService => throw UnimplementedError();
}
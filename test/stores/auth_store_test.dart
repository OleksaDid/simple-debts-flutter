import 'package:flutter_test/flutter_test.dart' as flutter_test;
import 'package:simpledebts/models/auth/auth_form.dart';
import 'package:simpledebts/store/auth.store.dart';
import 'package:test/test.dart';

import '../mocks/auth_service_mock.dart';

void main() {
  flutter_test.TestWidgetsFlutterBinding.ensureInitialized();

  group('Auth Store', () {
    AuthStore _authStore;
    setUp(() => _authStore = AuthStore(AuthServiceMock()));

    test('authData stream', () {
      expectLater(_authStore.authData$, emitsInOrder([
        null
      ]));
    });

    group('login', () {
      
      test('takes AuthForm, returns AuthData', () async {
        final data = await _authStore.login(_getMockAuthForm());
      });
    });
  });
}

AuthForm _getMockAuthForm() => AuthForm(
  email: 'test@test.com',
  password: 'qwerty12345'
);

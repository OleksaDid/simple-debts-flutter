import 'package:flutter/material.dart';
import 'package:simpledebts/models/auth/auth_data.dart';
import 'package:simpledebts/screens/auth_screen.dart';
import 'package:simpledebts/screens/base_screen_state.dart';
import 'package:simpledebts/screens/debts_list_screen.dart';
import 'package:simpledebts/screens/splash_screen.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends BaseScreenState<StartScreen> {

  @override
  Future<void> setupAuthReactions() async {
    await authStore.initAuthData();
    return super.setupAuthReactions();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AuthData>(
      future: authStore.autoLogin(),
      builder: (context, snapshot) {
        if(snapshot.connectionState == ConnectionState.waiting) {
          return SplashScreen();
        } else {
          return snapshot.data != null ? DebtsListScreen() : AuthScreen();
        }
      },
    );
  }
}
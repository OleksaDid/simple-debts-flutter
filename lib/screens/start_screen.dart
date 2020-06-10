import 'package:flutter/material.dart';
import 'package:simpledebts/screens/auth_screen.dart';
import 'package:simpledebts/screens/base_screen_state.dart';
import 'package:simpledebts/screens/debts_list_screen.dart';

class StartScreen extends StatefulWidget {
  @override
  _StartScreenState createState() => _StartScreenState();
}

class _StartScreenState extends BaseScreenState<StartScreen> {

  @override
  Widget build(BuildContext context) {
    return authStore.isAuthenticated ? DebtsListScreen() : AuthScreen();
  }
}
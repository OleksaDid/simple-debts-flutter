import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:simpledebts/screens/auth_screen.dart';
import 'package:simpledebts/store/auth_data_store.dart';

abstract class BaseScreenState<T extends StatefulWidget> extends State<T> {
  final authStore = GetIt.instance<AuthDataStore>();
  final List<ReactionDisposer> _reactionDisposers = [];

  @override
  void initState() {
    super.initState();
    setupAuthReactions();
  }

  @override
  void dispose() {
    _disposeReactions();
    super.dispose();
  }

  void addReactionDisposer(ReactionDisposer disposer) {
    _reactionDisposers.add(disposer);
  }

  Future<void> setupAuthReactions() async {
    _setupLogoutListener();
    _setupSharedPrefsListener();
  }

  
  void _setupLogoutListener() {
    addReactionDisposer(reaction(
      (_) => authStore.isAuthenticated,
      (isAuth) => isAuth == false ? Navigator.of(context).pushNamedAndRemoveUntil(
        AuthScreen.routeName,
        (Route<dynamic> route) => false
      ) : null)
    );
  }

  void _setupSharedPrefsListener() {
    addReactionDisposer(authStore.getSharedPreferencesDisposer());
  }
  
  void _disposeReactions() {
    _reactionDisposers.forEach((disposer) => disposer());
  }
}
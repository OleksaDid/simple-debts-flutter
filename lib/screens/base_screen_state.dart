import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:simpledebts/screens/auth_screen.dart';
import 'package:simpledebts/store/auth.store.dart';

abstract class BaseScreenState<T extends StatefulWidget> extends State<T> {
  final authStore = GetIt.instance<AuthStore>();
  final List<StreamSubscription> _observers = [];

  @override
  void initState() {
    super.initState();
    setupAuthReactions();
  }

  @override
  void dispose() {
    _closeSubscriptions();
    super.dispose();
  }

  void addSubscription(StreamSubscription subscription) {
    _observers.add(subscription);
  }

  Future<void> setupAuthReactions() async {
    _setupLogoutListener();
  }


  void _setupLogoutListener() {
    addSubscription(authStore
        .logout$
        .listen((logout) {
          print('LOGOUT $logout');
          Navigator.of(context).pushNamedAndRemoveUntil(
              AuthScreen.routeName,
                  (Route<dynamic> route) => false
          );
        })
    );
  }

  void _closeSubscriptions() {
    _observers.forEach((observer) => observer.cancel());
  }
}
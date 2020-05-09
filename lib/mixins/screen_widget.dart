import 'package:flutter/material.dart';

mixin ScreenWidget<T> on Widget {
  static String routeName;

  T getRouteArguments(BuildContext context) {
    return ModalRoute.of(context).settings.arguments as T;
  }
}
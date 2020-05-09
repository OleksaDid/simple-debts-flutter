import 'package:flutter/material.dart';

mixin SpinnerState<T extends StatefulWidget> on State<T> {
  @protected
  bool spinnerVisible = false;

  @protected
  void showSpinner() {
    setState(() => spinnerVisible = true);
  }

  @protected
  void hideSpinner() {
    setState(() => spinnerVisible = false);
  }
}
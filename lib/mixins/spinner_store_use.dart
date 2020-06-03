import 'package:flutter/material.dart';
import 'package:simpledebts/store/spinner_store.dart';

mixin SpinnerStoreUse {
  final _spinnerStore = SpinnerStore();

  bool get spinnerVisible => _spinnerStore.spinner;

  void showSpinner() => _spinnerStore.showSpinner();

  void hideSpinner() => _spinnerStore.hideSpinner();

  Widget spinnerContainer({
    @required Widget spinner,
    Widget replacement = const SizedBox.shrink()
  }) {
    return StreamBuilder(
      stream: _spinnerStore.spinner$,
      builder: (context, snapshot) => Visibility(
        visible: spinnerVisible,
        child: spinner,
        replacement: replacement,
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:simpledebts/store/spinner_store.dart';

mixin SpinnerStoreUse {
  final _spinnerStore = SpinnerStore();

  bool get spinnerVisible => _spinnerStore.spinnerVisible;

  void showSpinner() => _spinnerStore.showSpinner();

  void hideSpinner() => _spinnerStore.hideSpinner();

  Widget spinnerContainer({
    @required Widget spinner,
    Widget replacement = const SizedBox.shrink()
  }) {
    return Observer(
      builder: (context) => Visibility(
        visible: spinnerVisible,
        child: spinner,
        replacement: replacement,
      ),
    );
  }
}
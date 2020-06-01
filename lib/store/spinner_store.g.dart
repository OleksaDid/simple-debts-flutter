// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'spinner_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic

mixin _$SpinnerStore on _SpinnerStore, Store {
  final _$spinnerVisibleAtom = Atom(name: '_SpinnerStore.spinnerVisible');

  @override
  bool get spinnerVisible {
    _$spinnerVisibleAtom.reportRead();
    return super.spinnerVisible;
  }

  @override
  set spinnerVisible(bool value) {
    _$spinnerVisibleAtom.reportWrite(value, super.spinnerVisible, () {
      super.spinnerVisible = value;
    });
  }

  final _$_SpinnerStoreActionController =
      ActionController(name: '_SpinnerStore');

  @override
  void showSpinner() {
    final _$actionInfo = _$_SpinnerStoreActionController.startAction(
        name: '_SpinnerStore.showSpinner');
    try {
      return super.showSpinner();
    } finally {
      _$_SpinnerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  void hideSpinner() {
    final _$actionInfo = _$_SpinnerStoreActionController.startAction(
        name: '_SpinnerStore.hideSpinner');
    try {
      return super.hideSpinner();
    } finally {
      _$_SpinnerStoreActionController.endAction(_$actionInfo);
    }
  }

  @override
  String toString() {
    return '''
spinnerVisible: ${spinnerVisible}
    ''';
  }
}

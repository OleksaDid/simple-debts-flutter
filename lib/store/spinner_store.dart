import 'package:mobx/mobx.dart';

part 'spinner_store.g.dart';

class SpinnerStore = _SpinnerStore with _$SpinnerStore;

abstract class _SpinnerStore with Store {
  @observable
  bool spinnerVisible = false;

  @action
  void showSpinner() => spinnerVisible = true;

  @action
  void hideSpinner() => spinnerVisible = false;
}
import 'package:rxdart/rxdart.dart';

class SpinnerStore {
  final BehaviorSubject<bool> _spinner = BehaviorSubject.seeded(false);

  Stream<bool> get spinner$ => _spinner.stream;
  bool get spinner => _spinner.value;

  void showSpinner() => _spinner.add(true);

  void hideSpinner() => _spinner.add(false);
}
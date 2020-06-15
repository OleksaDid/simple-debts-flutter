import 'package:simpledebts/store/spinner_store.dart';
import 'package:test/test.dart';

void main() {
  group('Spinner Store', () {

    test('returns spinner stream with initial value == false', () {
      final spinnerStore = SpinnerStore();
      final spinner$ = spinnerStore.spinner$;
      spinner$.listen(expectAsync1((spinner) => spinner == false, count: 1));
    });

    test('returns spinner value', () {
      final spinnerStore = SpinnerStore();
      final spinner = spinnerStore.spinner;
      expect(spinner, false);
    });
    
    test('showSpinner changes value to true', () {
      final spinnerStore = SpinnerStore();
      expectLater(spinnerStore.spinner$, emitsInOrder([
        false,
        true
      ]));
      spinnerStore.showSpinner();
      expect(spinnerStore.spinner, true);
    });

    test('hideSpinner changes value to false', () {
      final spinnerStore = SpinnerStore();
      expectLater(spinnerStore.spinner$, emitsInOrder([
        false,
        false
      ]));
      spinnerStore.hideSpinner();
      expect(spinnerStore.spinner, false);
    });

    test('emits all changes', () {
      final spinnerStore = SpinnerStore();
      expectLater(spinnerStore.spinner$, emitsInOrder([
        false,
        true,
        false,
        false,
        true
      ]));
      spinnerStore.showSpinner();
      spinnerStore.hideSpinner();
      spinnerStore.hideSpinner();
      spinnerStore.showSpinner();
      expect(spinnerStore.spinner, true);
    });
  });
}
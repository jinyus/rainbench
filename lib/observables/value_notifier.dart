part of 'observable.dart';

class ValueNotifierObservable implements Observable {
  @override
  ObservableType get type => ObservableType.valueNotifier;

  var _notifier = ValueNotifier(0.0);

  ValueNotifier<double> get observable => _notifier;

  @override
  double get value => _notifier.value;

  @override
  set value(double value) {
    _notifier.value = value;
  }

  @override
  VoidCallback subscribe(void Function(double) callback) {
    void listener() {
      callback(_notifier.value);
    }

    _notifier.addListener(listener);

    return () => _notifier.removeListener(listener);
  }

  @override
  void dispose() {
    _notifier.dispose();
    _notifier = ValueNotifier(0.0);
  }
}

class ContextWatchValueNotifierObservable extends ValueNotifierObservable {
  @override
  final type = ObservableType.contextWatchVN;
}

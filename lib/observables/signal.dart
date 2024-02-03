part of 'observable.dart';

class SignalObservable implements Observable {
  @override
  ObservableType get type => ObservableType.signal;

  final _observable = signal(0.0);

  Signal<double> get observable => _observable;

  @override
  double get value => _observable.peek();

  @override
  set value(double value) => _observable.set(value);

  @override
  VoidCallback subscribe(void Function(double p1) callback) {
    return _observable.subscribe(callback);
  }

  @override
  @override
  void dispose() {
    _observable.dispose();
  }
}

class SignalObservableWatch implements Observable {
  @override
  ObservableType get type => ObservableType.signalWatch;

  final _observable = signal(0.0);

  Signal<double> get observable => _observable;

  @override
  double get value => _observable.peek();

  @override
  set value(double value) => _observable.set(value);

  @override
  VoidCallback subscribe(void Function(double p1) callback) {
    return _observable.subscribe(callback);
  }

  @override
  @override
  void dispose() {
    _observable.dispose();
  }
}

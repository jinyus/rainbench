part of 'observable.dart';

class SolidartObservable implements Observable {
  @override
  ObservableType get type => ObservableType.solidart;

  var _observable = solid.Signal(0.0);

  solid.Signal<double> get observable => _observable;

  @override
  double get value => _observable.value;

  @override
  set value(double value) => _observable.set(value);

  @override
  VoidCallback subscribe(void Function(double p1) callback) {
    return _observable.observe((p, n) => callback(n));
  }

  @override
  @override
  void dispose() {
    _observable.dispose();
    _observable = solid.Signal(0.0);
  }
}

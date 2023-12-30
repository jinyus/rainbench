part of 'observable.dart';

class BeaconObservable implements Observable {
  @override
  ObservableType get type => ObservableType.beacon;

  var _observable = Beacon.writable(0.0);

  WritableBeacon<double> get observable => _observable;

  @override
  double get value => _observable.peek();

  @override
  set value(double value) => _observable.set(value);

  @override
  VoidCallback subscribe(void Function(double p1) callback) {
    return _observable.subscribe(callback);
  }

  @override
  void dispose() {
    _observable.dispose();
    _observable = Beacon.writable(0.0);
  }
}

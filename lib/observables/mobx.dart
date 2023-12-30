part of 'observable.dart';

class MobxObservable implements Observable {
  @override
  ObservableType get type => ObservableType.mobx;

  var _observable = mx.Observable(0.0);

  mx.Observable<double> get observable => _observable;

  @override
  double get value => _observable.value;

  @override
  set value(double value) {
    // doesn't work in debug mode
    // as batching is enforced
    // _observable.value = value;

    final action = mx.Action(() {
      _observable.value = value;
    });

    action();
  }

  @override
  VoidCallback subscribe(void Function(double p1) callback) {
    void listener(mx.ChangeNotification<double> change) {
      if (change.newValue != null) {
        callback(change.newValue!);
      }
    }

    _observable.observe(listener);

    return () {};
  }

  @override
  void dispose() {
    _observable = mx.Observable(0.0);
  }
}

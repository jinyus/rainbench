part of 'observable.dart';

class StreamObservable implements Observable {
  @override
  ObservableType get type => ObservableType.stream;

  double _value = 0.0;
  var _controller = StreamController<double>.broadcast();

  @override
  set value(double value) {
    _value = value;
    _controller.add(value);
  }

  @override
  double get value => _value;

  Stream<double> get stream => _controller.stream;

  @override
  VoidCallback subscribe(void Function(double) callback) {
    final sub = _controller.stream.listen(callback);

    return sub.cancel;
  }

  @override
  void dispose() {
    _controller.close();
    _controller = StreamController<double>.broadcast();
  }
}

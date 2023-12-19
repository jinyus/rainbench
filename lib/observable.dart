// ignore_for_file: prefer_int_literals

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:mobx/mobx.dart' as mx;
import 'package:signals/signals_flutter.dart';
import 'package:state_beacon/state_beacon.dart';

enum ObservableType { beacon, signal, stream, valueNotifier, mobx }

final beaconObservable = BeaconObservable();
final signalObservable = SignalObservable();
final streamObservable = StreamObservable();
final valueNotifierObservable = ValueNotifierObservable();
final mobxObservable = MobxObservable();

sealed class Observable {
  ObservableType get type;
  set value(double value);
  double get value;
  VoidCallback subscribe(void Function(double) callback);
  void dispose();
}

class BeaconObservable implements Observable {
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
  ObservableType get type => ObservableType.beacon;

  @override
  void dispose() {
    _observable.dispose();
    _observable = Beacon.writable(0.0);
  }
}

class SignalObservable implements Observable {
  var _observable = signal(0.0);

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
  ObservableType get type => ObservableType.signal;

  @override
  void dispose() {
    _observable.dispose(); //not implemented yet
    _observable = signal(0.0);
  }
}

class StreamObservable implements Observable {
  @override
  final type = ObservableType.stream;
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

class ValueNotifierObservable implements Observable {
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
  ObservableType get type => ObservableType.valueNotifier;

  @override
  void dispose() {
    _notifier.dispose();
    _notifier = ValueNotifier(0.0);
  }
}

class MobxObservable implements Observable {
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
  ObservableType get type => ObservableType.mobx;

  @override
  void dispose() {
    _observable = mx.Observable(0.0);
  }
}

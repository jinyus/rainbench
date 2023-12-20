// ignore_for_file: prefer_int_literals

import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_solidart/flutter_solidart.dart' as solid;
import 'package:mobx/mobx.dart' as mx;
import 'package:signals/signals_flutter.dart';
import 'package:state_beacon/state_beacon.dart';

enum ObservableType {
  beacon('state_beacon'),
  signal('signals'),
  stream('stream'),
  valueNotifier('value_notifier'),
  contextWatchVN('context_watch VN'),
  mobx('mobx'),
  solidart('solidart');

  const ObservableType(this.name);

  final String name;
}

final beaconObservable = BeaconObservable();
final signalObservable = SignalObservable();
final streamObservable = StreamObservable();
final valueNotifierObservable = ValueNotifierObservable();
final contextWatchVNObservable = ContextWatchValueNotifierObservable();
final mobxObservable = MobxObservable();
final solidartObservable = SolidartObservable();

sealed class Observable {
  ObservableType get type;
  set value(double value);
  double get value;
  VoidCallback subscribe(void Function(double) callback);
  void dispose();

  static Observable fromString(String? type) {
    final obsType = ObservableType.values.firstWhere((e) => e.name == type);

    return switch (obsType) {
      ObservableType.beacon => beaconObservable,
      ObservableType.signal => signalObservable,
      ObservableType.stream => streamObservable,
      ObservableType.valueNotifier => valueNotifierObservable,
      ObservableType.contextWatchVN => contextWatchVNObservable,
      ObservableType.mobx => mobxObservable,
      ObservableType.solidart => solidartObservable,
    };
  }
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

class ContextWatchValueNotifierObservable extends ValueNotifierObservable {
  @override
  final type = ObservableType.contextWatchVN;
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

class SolidartObservable implements Observable {
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
  ObservableType get type => ObservableType.solidart;

  @override
  void dispose() {
    _observable.dispose();
    _observable = solid.Signal(0.0);
  }
}

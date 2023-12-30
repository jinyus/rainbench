import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_solidart/flutter_solidart.dart' as solid;
import 'package:mobx/mobx.dart' as mx;
import 'package:signals/signals_flutter.dart';
import 'package:state_beacon/state_beacon.dart';

part 'beacon.dart';
part 'signal.dart';
part 'mobx.dart';
part 'solidart.dart';
part 'stream.dart';
part 'value_notifier.dart';

enum ObservableType {
  beacon('state_beacon'),
  beaconVN('state_beacon VN'),
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
      ObservableType.beaconVN => beaconObservable,
      ObservableType.signal => signalObservable,
      ObservableType.stream => streamObservable,
      ObservableType.valueNotifier => valueNotifierObservable,
      ObservableType.contextWatchVN => contextWatchVNObservable,
      ObservableType.mobx => mobxObservable,
      ObservableType.solidart => solidartObservable,
    };
  }
}

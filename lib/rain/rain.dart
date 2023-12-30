import 'package:context_watch/context_watch.dart' as cw;
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart' as fmx;
import 'package:rainbench/main.dart';
import 'package:rainbench/observables/observable.dart';
import 'package:signals/signals_flutter.dart';

part 'beacon.dart';
part 'mobx.dart';
part 'signal.dart';
part 'stream.dart';
part 'value_notifier.dart';
// part 'solidart.dart';

const columns = 15; // 10 drops per row
// Horizontal and vertical spacing between drops
const dropSpacing = 20.0;
const initialTopOffset = 20.0; // Initial top offset (below the cloud)
const dropWidth = 15.0; // Width of each raindrop icon
const dropsInRow = columns;
const totalRowWidth = dropWidth * dropsInRow + dropSpacing * (dropsInRow - 1);

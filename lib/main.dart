// ignore_for_file: lines_longer_than_80_chars, prefer_const_constructors, inference_failure_on_instance_creation

import 'dart:async';

import 'package:context_watch/context_watch.dart';
import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:rainbench/observables/observable.dart';
import 'package:rainbench/rain/rain.dart';
import 'package:rainbench/rain/solidart.dart';
import 'package:signals/signals_flutter.dart';
import 'package:state_beacon/state_beacon.dart';

final currentObservable = Beacon.writable<Observable>(beaconObservable);

Timer? timer;
final stopwatch = Stopwatch();

// Rain drop position (0-25, bottom-top)
final rainingSignal = signal(0.0);

// Bucket fill percentage (0-100)
final bucketFillBeacon = Beacon.writable(0.0);

const _rainSpeed = 0.1;

// Number of raindrops to fill bucket
final _bucketCapacity = Beacon.writable(20000);

// Number of raindrops falling
final rainDropCount = Beacon.writable(5000);

final showBeacon = Beacon.writable(false);

class ToolBar extends StatefulWidget {
  const ToolBar({super.key});

  static const rainDropCounts = {
    500: '500',
    5000: '5k',
    10000: '10k',
    20000: '20k',
  };
  static const bucketCapacities = {
    5000: '5k',
    15000: '15k',
    20000: '20k',
    30000: '30k',
    50000: '50k',
    100000: '100k',
  };
  static const List<double> rainSpeeds = [0.05, 0.1, 0.15, 0.2];

  @override
  State<ToolBar> createState() => _ToolBarState();
}

class _ToolBarState extends State<ToolBar> {
  VoidCallback? unsub;

  @override
  Widget build(BuildContext context) {
    final obs = currentObservable.watch(context);
    return SizedBox(
      width: double.infinity,
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        runAlignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          Text('Raindrops: '),
          DropdownButton<int>(
            value: rainDropCount.watch(context),
            onChanged: (newValue) {
              rainDropCount.set(newValue!);
            },
            items: ToolBar.rainDropCounts.keys
                .map<DropdownMenuItem<int>>((int key) {
              return DropdownMenuItem<int>(
                value: key,
                child: Text(ToolBar.rainDropCounts[key]!),
              );
            }).toList(),
          ),
          Text('Bucket Capacity: '),
          DropdownButton(
            value: _bucketCapacity.watch(context),
            onChanged: (newValue) {
              _bucketCapacity.set(newValue!);
            },
            items: ToolBar.bucketCapacities.keys.map((int key) {
              return DropdownMenuItem<int>(
                value: key,
                child: Text(ToolBar.bucketCapacities[key]!),
              );
            }).toList(),
          ),
          Text('Type: '),
          DropdownButton(
            value: currentObservable.watch(context).type.name,
            onChanged: (newValue) {
              final observable = Observable.fromString(newValue);
              currentObservable.set(observable);
            },
            items: ObservableType.values.map((type) {
              return DropdownMenuItem(
                value: type.name,
                child: Text(type.name),
              );
            }).toList(),
          ),
          const SizedBox(width: 20.0),
          ElevatedButton(
            onPressed: () {
              showBeacon.value = true;
              unsub?.call();
              unsub = obs.subscribe((v) {
                // print('${currentObservable.peek()} with $v');
                if (obs.value >= 25) {
                  // Reset raindrop position
                  obs.value = 0.0;

                  // Increment bucket fill
                  bucketFillBeacon.value += rainDropCount.peek();

                  if (bucketFillBeacon.value >= _bucketCapacity.peek()) {
                    stopwatch.stop(); // Stop timer when bucket full
                    timer?.cancel(); // Stop raining
                    unsub?.call(); // Stop listening to raindrop position
                    obs.dispose();

                    final tookSeconds =
                        stopwatch.elapsed.inMilliseconds / 1000.0;
                    final raindropsPerSecond =
                        (_bucketCapacity.peek() / tookSeconds)
                            .toStringAsFixed(2);

                    showBeacon.value = false;

                    showDialog<AlertDialog>(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: const Text('Benchmark Finished!'),
                        content: Text(
                          'Time to fill bucket: $tookSeconds seconds'
                          '\n$raindropsPerSecond raindrops/sec',
                          style: const TextStyle(fontSize: 30.0),
                        ),
                      ),
                    );
                  }
                }
              });

              obs.value = 0.0;
              bucketFillBeacon.value = 0.0;
              stopwatch
                ..reset()
                ..start();

              timer?.cancel();
              timer = Timer.periodic(const Duration(milliseconds: 1), (timer) {
                // Update raindrop position
                obs.value += _rainSpeed;
              });
            },
            child: const Text('Start'),
          ),
          const SizedBox(width: 20.0),
          ElevatedButton(
            onPressed: () {
              unsub?.call();
              obs.value = 0.0;
              bucketFillBeacon.value = 0.0;
              stopwatch.reset();
              timer?.cancel();
              showBeacon.value = false;
              obs.dispose();
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }
}

class Progress extends StatelessWidget {
  const Progress({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Builder(
        builder: (ctx) {
          final per = bucketFillBeacon.watch(ctx) / _bucketCapacity.peek();
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Bucket Fill: ${(per * 100).toStringAsFixed(2)}%'),
              LinearProgressIndicator(
                minHeight: 20.0,
                color: Colors.blue,
                value: per,
                // value: 0.5,
              ),
            ],
          );
        },
      ),
    );
  }
}

class Clouds extends StatelessWidget {
  const Clouds({
    required this.screenWidth,
    super.key,
  });

  final double screenWidth;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Align(
          alignment: Alignment.topCenter,
          child: Icon(Icons.cloud, size: screenWidth / 5),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Icon(Icons.cloud, size: screenWidth / 5),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Icon(Icons.cloud, size: screenWidth / 5),
        ),
      ],
    );
  }
}

const emptyText = 'Rainbench is designed to test the throughput of '
    "different reactive libraries. It's a simple benchmark "
    'that fills a bucket with raindrops. \nEach rain drop creates a subcription '
    'and the observable gets updated every millisecond, which should trigger a '
    'rebuild of each rain drop with its new position. \nThe number of raindrops '
    'and the capacity of the bucket can be adjusted. The benchmark '
    'will run until the bucket is full. The time it takes to fill '
    'the bucket is recorded and displayed at the end of the benchmark.';

class BenchmarkPage extends StatelessWidget {
  const BenchmarkPage({super.key});

  @override
  Widget build(BuildContext context) {
    final show = showBeacon.watch(context);
    final obs = currentObservable.watch(context);
    final style = TextStyle(fontSize: 30.0);
    return Scaffold(
      appBar: AppBar(title: ToolBar(), toolbarHeight: 100),
      body: show
          ? switch (obs.type) {
              ObservableType.beacon => BeaconRain(),
              ObservableType.beaconVN => BeaconValueNotifierRain(),
              ObservableType.signal => SignlaRain(),
              ObservableType.stream => StreamRain(),
              ObservableType.contextWatchVN => ContextWatchValueNotifierRain(),
              ObservableType.valueNotifier => ValueNotifierRain(),
              ObservableType.mobx => MobXRain(),
              ObservableType.solidart => SolidartRain(),
            }
          : Center(
              child: SizedBox(
                width: MediaQuery.of(context).size.width * .6,
                child: Text(emptyText, style: style),
              ),
            ),
    );
  }
}

void main() {
  disableSignalsDevTools();
  SolidartConfig.devToolsEnabled = false;
  runApp(
    ContextWatchRoot(
      child: const MaterialApp(home: BenchmarkPage()),
    ),
  );
}

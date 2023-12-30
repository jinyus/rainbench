import 'package:flutter/material.dart';
import 'package:flutter_solidart/flutter_solidart.dart';
import 'package:rainbench/main.dart';
import 'package:rainbench/observables/observable.dart';
import 'package:rainbench/rain/rain.dart';

class SolidartRain extends StatelessWidget {
  const SolidartRain({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Stack(
      children: [
        // Cloud at top
        Clouds(screenWidth: screenWidth),
        const Progress(),

        // Raining drops based on beacon position
        for (int i = 0; i < rainDropCount.peek(); i++)
          SignalBuilder(
            signal: solidartObservable.observable,
            builder: (_, val, __) {
              final startingLeftOffset = (screenWidth - totalRowWidth) / 2;
              final row = i ~/ columns;
              final col = i % columns;
              return Positioned(
                left: startingLeftOffset + col * (dropWidth + dropSpacing),
                top: initialTopOffset +
                    row * dropSpacing +
                    200.0 * (1 + (val * .1)),
                child: const Icon(
                  Icons.water_drop,
                  size: dropWidth,
                  color: Colors.blue,
                ),
              );
            },
          ),
      ],
    );
  }
}

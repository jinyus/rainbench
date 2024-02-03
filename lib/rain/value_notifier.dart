part of 'rain.dart';

class ValueNotifierRain extends StatelessWidget {
  const ValueNotifierRain({super.key});

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
          ValueListenableBuilder(
            valueListenable: valueNotifierObservable.observable,
            builder: (ctx, val, child) {
              // print('VN $val');
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

// NOT WORKING:
// Rebuilds but has the same value
class ContextWatchValueNotifierRain extends StatelessWidget {
  const ContextWatchValueNotifierRain({super.key});

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
          Builder(
            builder: (context) {
              final startingLeftOffset = (screenWidth - totalRowWidth) / 2;
              final row = i ~/ columns;
              final col = i % columns;
              final val = cw.ValueListenableContextWatchExtension(
                contextWatchVNObservable.observable,
              ).watch(context);

              // print('val: $val');

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

class BeaconValueNotifierRain extends StatelessWidget {
  const BeaconValueNotifierRain({super.key});

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
          ValueListenableBuilder(
            valueListenable: beaconObservableVn.observable.toListenable(),
            builder: (ctx, val, child) {
              // print('VN $val');
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

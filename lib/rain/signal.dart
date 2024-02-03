part of 'rain.dart';

class SignalRain extends StatelessWidget {
  const SignalRain({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
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
              final val = signalObservable.observable.watch(context);
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

class SignalRainWatch extends StatelessWidget {
  const SignalRainWatch({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    return Stack(
      children: [
        // Cloud at top
        Clouds(screenWidth: screenWidth),
        const Progress(),

        // Raining drops based on beacon position
        for (int i = 0; i < rainDropCount.peek(); i++)
          Watch(
            (BuildContext context) {
              final startingLeftOffset = (screenWidth - totalRowWidth) / 2;
              final val = signalObservableWatch.observable.value;
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

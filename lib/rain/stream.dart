part of 'rain.dart';

class StreamRain extends StatelessWidget {
  const StreamRain({super.key});

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
          StreamBuilder(
            stream: streamObservable.stream,
            builder: (ctx, snapshot) {
              final val = snapshot.data;

              if (val == null) return const SizedBox.shrink();

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

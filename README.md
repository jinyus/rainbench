Rainbench is designed to test the throughput of different reactive libraries. It's a simple benchmark that fills a bucket with raindrops.

Each rain drop creates a subscription, and the observable gets updated every millisecond,
which should trigger a rebuild of each rain drop widget with its new position.

The number of raindrops and the capacity of the bucket can be adjusted. The benchmark will run until the bucket is full. The time it takes to fill the bucket is recorded and displayed at the end of the benchmark.

> [!NOTE]  
> This is a stress test so don't put too much stock in the results as real apps will typically have a lot less updates/subscriptions.

## Results

-   Release mode on linux
-   The benchmark is restarted after each run to prevent GC interference
-   value_LB == value_listenable_builder
-   `stream_builder` and `value_LB` are not perfect comparisons as they can only listen to 1 observable at a time... but they serve as a good baseline
-   `solidart` implementation uses `SolidBuilder` which can only listen to a fixed number of observables so it's not a perfect comparison either.

### 20k raindrops and a bucket capacity of 30k

| Library                                                 | Raindrops/s | Time to fill bucket |
|---------------------------------------------------------|-------------|---------------------|
| [state_beacon](https://pub.dev/packages/state_beacon)   | 5337        | 5.62s               |
| value_LB                                                | 5030        | 5.96s               |
| [mobx](https://pub.dev/packages/flutter_mobx)           | 4618        | 6.50s               |
| [solidart](https://pub.dev/packages/solidart)           | 3843        | 7.81s               |
| [signals](https://pub.dev/packages/signals)             | 2011        | 14.91s              |
| stream_builder                                          | 1461        | 20.52s              |
| [context_watch](https://pub.dev/packages/context_watch) | 1209        | 24.80s              |

## Video:

https://github.com/jinyus/rainbench/assets/30532952/e90f56b3-8ba9-44e8-996d-1c240bc3fa70

## RydMike - Updated test runs (Feb 3, 2024)

- Updated to use the latest version of each library
- Added Signals option to use Watch instead of context.watch.
- Fixed capability to actually select the option to use ValueNotifier with State Beacon.
- Tested in release mode on macOS (M1 Pro), with Flutter 2.16.9.
- The benchmark is restarted after each run to prevent GC interference.
- Used 20k raindrops and a bucket capacity of 200k for longer tests.

### 20k raindrops and a bucket capacity of 200k

| Library                                                      | Raindrops/s | Time to fill bucket |
|--------------------------------------------------------------|-------------|---------------------|
| 1 [state_beacon](https://pub.dev/packages/state_beacon)      | 20288       | 9.9s                |
| 2 [mobx](https://pub.dev/packages/flutter_mobx)              | 12934       | 15.5s               |
| 3 [state_beacon VN](https://pub.dev/packages/state_beacon)   | 9467        | 21.1s               |
| 4 value_LB (Throws exceptions after completion!!!)           | 9450        | 21.1s               |
| 5 [solidart](https://pub.dev/packages/solidart)              | 9466        | 21.1s               |
| 6 [signals Watch](https://pub.dev/packages/signals)          | 8662        | 23.1s               |
| 7 [signals context(watch)](https://pub.dev/packages/signals) | 7843        | 25.5s               |
| 8 [context_watch](https://pub.dev/packages/context_watch)    | 5504        | 36.3s               |
| 9 stream_builder                                             | 4549        | 44.0s               |

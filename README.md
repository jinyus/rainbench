Rainbench is designed to test the throughput of different reactive libraries. It's a simple benchmark that fills a bucket with raindrops.

Each rain drop creates a subscription, and the observable gets updated every millisecond,
which should trigger a rebuild of each rain drop widget with its new position.

The number of raindrops and the capacity of the bucket can be adjusted. The benchmark will run until the bucket is full. The time it takes to fill the bucket is recorded and displayed at the end of the benchmark.

> [!NOTE]  
> This is a stress test so don't put too much stock in the results as real apps will typically have a lot less updates/subscriptions.

## Results (Dec 30, 2023)

-   Release mode on linux.
-   The benchmark is restarted after each run to prevent GC interference.
-   value_LB stand for `ValueListenableBuilder`.
-   `stream_builder` and `value_LB` are not perfect comparisons as they can only listen to one observable at a time,  but they serve as a good baseline.
-   `solidart` implementation uses `SolidBuilder` which can only listen to a fixed number of observables, so it's not a perfect comparison either.

### 20k raindrops and a bucket capacity of 30k

| Library                                                    | Raindrops/s | Time to fill bucket |
|------------------------------------------------------------|-------------|---------------------|
| [state_beacon](https://pub.dev/packages/state_beacon)      | 5337        | 5.62s               |
| value_LB                                                   | 5030        | 5.96s               |
| [mobx](https://pub.dev/packages/flutter_mobx)              | 4618        | 6.50s               |
| [solidart](https://pub.dev/packages/solidart)              | 3843        | 7.81s               |
| [signals watch(context)](https://pub.dev/packages/signals) | 2011        | 14.91s              |
| stream_builder                                             | 1461        | 20.52s              |
| [context_watch](https://pub.dev/packages/context_watch)    | 1209        | 24.80s              |

## Video:

https://github.com/jinyus/rainbench/assets/30532952/e90f56b3-8ba9-44e8-996d-1c240bc3fa70

## Updated test runs (Feb 3, 2024)
### Third party results by [RydMike](https://twitter.com/RydMike)

- Updated to use the latest version of each library
- Added Signals option to use Watch instead of context.watch.
- Fixed the feature to actually select the option to use ValueNotifier with State Beacon.
- Tested in release mode on macOS (M1 Pro), with Flutter 3.16.9.
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
| 7 [signals watch(context)](https://pub.dev/packages/signals) | 7843        | 25.5s               |
| 8 [context_watch](https://pub.dev/packages/context_watch)    | 5504        | 36.3s               |
| 9 stream_builder                                             | 4549        | 44.0s               |

## Updated test runs (April 13, 2024)
### Third party results by [RydMike](https://twitter.com/RydMike)

- Updated to use the latest version of each library, tested version are:
  - flutter: 3.19.5
  - context_watch: ^3.1.1
  - mobx: ^2.3.3+2
  - flutter_mobx: ^2.2.1+1
  - flutter_solidart: ^1.7.1
  - signals: ^5.0.0
  - state_beacon: ^0.45.0
- Tested in release mode on macOS (M1 Pro), with Flutter 3.19.5.
- The benchmark is restarted after each run to prevent GC interference.
- Used 20k raindrops and a bucket capacity of 200k for longer tests.

### 20k raindrops and a bucket capacity of 200k

| Library                                                      | Raindrops/s | Time to fill bucket |
|--------------------------------------------------------------|-------------|---------------------|
| 1 [state_beacon](https://pub.dev/packages/state_beacon)      | 24105       | 8.3s                |
| 2 [mobx](https://pub.dev/packages/flutter_mobx)              | 13767       | 14.5s               |
| 3 [solidart](https://pub.dev/packages/solidart)              | 10867       | 18.4s               |
| 4 [state_beacon VN](https://pub.dev/packages/state_beacon)   | 10230       | 19.5s               |
| 5 value_LB (Throws exceptions after completion!!!)           | 10227       | 19.6s               |
| 6 [signals watch(context)](https://pub.dev/packages/signals) | 6723        | 29.7s               |
| 7 [signals Watch](https://pub.dev/packages/signals)          | 5755        | 34.8s               |
| 8 stream_builder                                             | 4621        | 43.3s               |
| 9 [context_watch](https://pub.dev/packages/context_watch)    | 4040        | 49.5s               |

> [!NOTE]
> 
> **ValueNotifierBuilder** 
> - The `value_LB` and `context_watch` (also using `ValueListenableBuilder`) implementations throw exceptions after the test is complete and bucket is full. Thrown exception message in release build: `Another exception was thrown: Instance of 'DiagnosticsProperty<void>'`.
>
> **Signals**
> - The two `signals` implementation benchmarks can only be selected and run once in the benchmark. If selected again or trying to run any of them again, they do not re-run. When using signals version `4.5.1` the same behavior was observed. If stepping down to version `3.0.0` as used in tests **Feb 3, 2024**, the two `signals` benchmarks can be selected and rerun many times. 
> - When benchmarking `signals` with version `3.0.0` again in, we got roughly the same results as in the **Feb 3, 2024** test runs. With version `4.5.1` the `signals watch(context)` benchmark completed at **22.1s** and with **9043 raindrops/s**.
> - **Findings**: After version 3.0.0 something broke this benchmark, with respect to that you cannot rerun a `signals` benchmark in it, you have to restart the benchmark app. This was done anyway to avoid GC interference, but something odd is up with the benchmark. Also of version 3.0.0, 4.5.1 and 5.0.0, the newest one is the slowest version. 
> - **Recommendation:** Signal author should review the benchmark's functionality. Why does it partially break after version 3.0.0? Additionally, for this particular benchmark `signals` performance has decreased.

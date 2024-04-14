Rainbench is designed to test the throughput of different reactive libraries. It's a simple benchmark that fills a bucket with raindrops.

Each rain drop creates a subscription, and the observable gets updated every millisecond,
which should trigger a rebuild of each rain drop widget with its new position.

The number of raindrops and the capacity of the bucket can be adjusted. The benchmark will run until the bucket is full. The time it takes to fill the bucket is recorded and displayed at the end of the benchmark.

> [!NOTE]  
> This is a stress test so don't put too much stock in the results as real apps will typically have a lot less updates/subscriptions.

## Benchmark Results 1 (Dec 30, 2023)

-   Release mode on linux.
-   The benchmark app is restarted after each run to prevent GC interference.
-   The `value_notifier` benchmark stands for `ValueListenableBuilder`.
-   `stream_builder` and `value_notifier` are not perfect comparisons as they can only listen to one observable at a time,  but they serve as a good baseline.
-   `solidart` implementation uses `SolidBuilder` which can only listen to a fixed number of observables, so it's not a perfect comparison either.

### 20k raindrops and a bucket capacity of 30k

| Library                                                      | Raindrops/s | Time to fill bucket | Factor |
|--------------------------------------------------------------|-------------|---------------------|--------|
| 1 [state_beacon](https://pub.dev/packages/state_beacon)      | 5337        | 5.62s               | 1.00   |
| 2 value_notifier (ValueListenableBuilder)                    | 5030        | 5.96s               | 1.06   |
| 3 [mobx](https://pub.dev/packages/flutter_mobx)              | 4618        | 6.50s               | 1.16   |
| 4 [solidart](https://pub.dev/packages/solidart)              | 3843        | 7.81s               | 1.39   |
| 5 [signals watch(context)](https://pub.dev/packages/signals) | 2011        | 14.91s              | 2.65   |
| 6 stream_builder                                             | 1461        | 20.52s              | 3.65   |
| 7 [context_watch VN](https://pub.dev/packages/context_watch) | 1209        | 24.80s              | 4.41   |

## Video:

https://github.com/jinyus/rainbench/assets/30532952/e90f56b3-8ba9-44e8-996d-1c240bc3fa70

## Benchmark Results 2 (Feb 3, 2024)
_Third party results by [RydMike](https://twitter.com/RydMike)_

- Updated to use the latest version of each library, tested versions:
  - flutter: 3.16.9
  - context_watch: 1.0.2
  - mobx: 2.3.0
  - flutter_mobx: 2.2.0+2
  - flutter_solidart: 1.7.0
  - signals: 3.0.0
  - state_beacon: ^0.33.1
- Added Signals option to use Watch instead of context.watch.
- Fixed the feature to actually select the option to use VN (ValueListenableBuilder) with StateBeacon.
- Tested in release mode on macOS (M1 Pro 32GB ram).
- The benchmark app is restarted after each run to prevent GC interference.
- Used 20k raindrops and a bucket capacity of 200k for longer tests.

### 20k raindrops and a bucket capacity of 200k

| Library                                                      | Raindrops/s | Time to fill bucket | Factor |
|--------------------------------------------------------------|-------------|---------------------|--------|
| 1 [state_beacon](https://pub.dev/packages/state_beacon)      | 20288       | 9.9s                | 1.00   |
| 2 [mobx](https://pub.dev/packages/flutter_mobx)              | 12934       | 15.5s               | 1.57   |
| 3 [state_beacon VN](https://pub.dev/packages/state_beacon)   | 9467        | 21.1s               | 2.13   |
| 4 value_notifier (ValueListenableBuilder)                    | 9450        | 21.1s               | 2.13   |
| 5 [solidart](https://pub.dev/packages/solidart)              | 9466        | 21.1s               | 2.13   |
| 6 [signals Watch](https://pub.dev/packages/signals)          | 8662        | 23.1s               | 2.33   |
| 7 [signals watch(context)](https://pub.dev/packages/signals) | 7843        | 25.5s               | 2.58   |
| 8 [context_watch](https://pub.dev/packages/context_watch)    | 5504        | 36.3s               | 3.67   |
| 9 stream_builder                                             | 4549        | 44.0s               | 4.44   |

## Benchmark Results 3 (April 14, 2024)
_Third party results by [RydMike](https://twitter.com/RydMike)_

- Updated to use the latest version of each library, tested versions:
  - flutter: 3.19.5
  - context_watch: 3.1.1
  - mobx: 2.3.3+2
  - flutter_mobx: 2.2.1+1
  - flutter_solidart: 1.7.1
  - signals: 5.0.0
  - state_beacon: 0.45.0
- Tested in release mode on macOS (M1 Pro, same laptop as in Results 2)
- The benchmark app is restarted after each run to prevent GC interference.
- Used same 20k raindrops and a bucket capacity of 200k for longer tests, as in Results 2.

### 20k raindrops and a bucket capacity of 200k

| Library                                                      | Raindrops/s | Time to fill bucket | Factor |
|--------------------------------------------------------------|-------------|---------------------|--------|
| 1 [state_beacon](https://pub.dev/packages/state_beacon)      | 24105       | 8.3s                | 1.00   |
| 2 [mobx](https://pub.dev/packages/flutter_mobx)              | 13767       | 14.5s               | 1.75   |
| 3 [solidart](https://pub.dev/packages/solidart)              | 10867       | 18.4s               | 2.22   |
| 4 [state_beacon VN](https://pub.dev/packages/state_beacon)   | 10230       | 19.5s               | 2.35   |
| 5 value_notifier (ValueListenableBuilder)                    | 10227       | 19.6s               | 2.36   |
| 6 [signals watch(context)](https://pub.dev/packages/signals) | 6804        | 29.4s               | 3.54   |
| 7 [signals Watch](https://pub.dev/packages/signals)          | 5603        | 35.7s               | 4.30   |
| 8 stream_builder                                             | 4621        | 43.3s               | 5.22   |
| 9 [context_watch](https://pub.dev/packages/context_watch)    | 4040        | 49.5s               | 5.96   |

> [!NOTE]
> 
> **ValueNotifierBuilder** 
> - In results 2 and 3, the `value_notifier` and `context_watch` (also using `ValueListenableBuilder`) implementations throw exceptions after the test is complete and bucket is full. Thrown exception message in release build: `Another exception was thrown: Instance of 'DiagnosticsProperty<void>'`. 
>
> **Signals**
> - When benchmarking `signals` with version `3.0.0` again **April 14, 2024**, we got roughly the same results as in the **Feb 3, 2024** test runs. With version `4.5.1` the `signals watch(context)` benchmark completed at **22.1s** and with **9043 raindrops/s**.
> - **Findings**: Comparing versions 3.0.0, 4.5.1 and 5.0.0, the newest version is the slowest one. 
> - **Recommendation:** Signals author should consider reviewing the results. For this particular benchmark `signals` performance has decreased. Signals is also the slowest signals library in this benchmark.

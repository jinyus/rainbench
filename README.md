Rainbench is designed to test the throughput of different reactive libraries. It's a simple benchmark that fills a bucket with raindrops.

Each rain drop creates a subcription and the observable gets updated every millisecond, which should trigger a rebuild of each rain drop widget with its new position.

The number of raindrops and the capacity of the bucket can be adjusted. The benchmark will run until the bucket is full. The time it takes to fill the bucket is recorded and displayed at the end of the benchmark.

> [!NOTE]  
> This is a stress test so don't put too much stock in the results as real apps will typically have a lot less updates/subscriptions.

## Results

-   Release mode on linux
-   Benchmark is restarted after each run to prevent GC interference
-   value_LB == value_listenable_builder
-   `stream_builder` and `value_LB` are not perfect comparisons as they can only listen to 1 observable at a time... but they serve as a good baseline
-   `solidart` implementation uses `SolidBuilder` which can only listen to a fixed number of observables so it's not a perfect comparison either.

### 20k raindrops and a bucket capacity of 30k

| Library                                                 | Raindrops/s | Time to fill bucket |
| ------------------------------------------------------- | ----------- | ------------------- |
| [state_beacon](https://pub.dev/packages/state_beacon)   | 5337        | 5.62s               |
| value_LB                                                | 5030        | 5.96s               |
| [mobx](https://pub.dev/packages/flutter_mobx)           | 4618        | 6.50s               |
| [solidart](https://pub.dev/packages/solidart)           | 3843        | 7.81s               |
| [signals](https://pub.dev/packages/signals)             | 2011        | 14.91s              |
| stream_builder                                          | 1461        | 20.52s              |
| [context_watch](https://pub.dev/packages/context_watch) | 1209        | 24.80s              |

## Video:

https://github.com/jinyus/rainbench/assets/30532952/e90f56b3-8ba9-44e8-996d-1c240bc3fa70



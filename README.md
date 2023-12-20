Rainbench is designed to test the throughput of different reactive libraries. It's a simple benchmark that fills a bucket with raindrops.

Each rain drop creates a subcription and the observable gets updated every millisecond, which should trigger a rebuild of each rain drop widget with its new position.

The number of raindrops and the capacity of the bucket can be adjusted. The benchmark will run until the bucket is full. The time it takes to fill the bucket is recorded and displayed at the end of the benchmark.

## Results

-   Release mode on linux
-   Benchmark is restarted after each run to prevent GC interference
-   value_LB == value_listenable_builder
-   `stream_builder` and `value_LB` are not perfect comparisons as they can only listen to 1 observable at a time... but they serve as a good baseline

### 20k raindrops and a bucket capacity of 30k

| Library                                                 | Raindrops/s | Time to fill bucket |
| ------------------------------------------------------- | ----------- | ------------------- |
| [state_beacon](https://pub.dev/packages/state_beacon)   | 6112        | 4.91s               |
| value_LB                                                | 5301        | 5.66s               |
| [mobx](https://pub.dev/packages/flutter_mobx)           | 4463        | 6.72s               |
| [signals](https://pub.dev/packages/signals)             | 1868        | 16.06s              |
| stream_builder                                          | 1597        | 18.78s              |
| [context_watch](https://pub.dev/packages/context_watch) | 1245        | 24.01s              |
| [solidart](https://pub.dev/packages/solidart)           | DNF         | DNF                 |

## Video:

https://github.com/jinyus/rainbench/assets/30532952/40946543-74cd-45f3-a726-27f9ddc1bd6a

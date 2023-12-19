Rainbench is designed to test the throughput of different reactive libraries. Its a simple benchmark that fills a bucket with raindrops. \nEach rain drop creates a subcription and the observable gets updated every microsecond, which should trigger a rebuild of each rain drop with its new position. \nThe number of raindrops and the capacity of the bucket can be adjusted. The benchmark will run until the bucket is full. The time it takes to fill the bucket is recorded and displayed at the end of the benchmark.

## Results

-   Release mode on linux
-   Benchmark is restarted after each run to prevent GC interference
-   value_LB == value_listenable_builder
-   `stream_builder` and `value_LB` are not perfect comparisons as they can only listen to 1 observable at a time... but they serve as a good baseline

### 5k raindrops and a bucket capacity of 20k

| Library        | Raindrops/s                       | Time to fill bucket                |
| -------------- | --------------------------------- | ---------------------------------- |
| value_LB       | $\textsf{\color{lightgreen}8838}$ | $\textsf{\color{lightgreen}2.26s}$ |
| stream_builder | 8035                              | 2.49s                              |
| state_beacon   | 7837                              | 2.55s                              |
| signals        | 7457                              | 2.68s                              |
| mobx           | 6194                              | 3.23s                              |

### 20k raindrops and a bucket capacity of 30k

| Library        | Raindrops/s                       | Time to fill bucket                |
| -------------- | --------------------------------- | ---------------------------------- |
| state_beacon   | $\textsf{\color{lightgreen}5778}$ | $\textsf{\color{lightgreen}5.19s}$ |
| value_LB       | 3967                              | 7.56s                              |
| mobx           | 2849                              | 10.53s                             |
| stream_builder | 1867                              | 16.01s                             |
| signals        | 1798                              | 16.69s                             |

## Video of the 20k run:

https://github.com/jinyus/rainbench/assets/30532952/40946543-74cd-45f3-a726-27f9ddc1bd6a


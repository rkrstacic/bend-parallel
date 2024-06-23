[Bend official GitHub](https://github.com/HigherOrderCO/bend/blob/main/GUIDE.md)

To run the code, run in terminal
```
bend run src/main.bend -s
```

To run the code in paralel mode, run in terminal
```
bend run-c src/main.bend -s
```

## Task
> Having an array of numbers create a histogram that counts the number of elements for each range group.

### Benchmark (1 mil, 3 groups):

```
src/histogram/0_naive_hist.bend
Sequential - 10.59s
Paralel    - 6.40s
```
```
src/histogram/1_2split_hist.bend:
Sequential - 7.52s
Paralel    - 3.19s
```
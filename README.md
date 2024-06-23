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

Current personal best: `1.2s` on paralel run

### Approach

First i wanted to create sequential histogram in bend. This was a good exercise to learn the language and get comfortable with it. I got 10s on sequential run (Seq) and 6.5 seconds on paralel run (Par) with c interpreter on M2 chip. From what i have practiced, i have encountered much greater benefits from Par runs than x2 speed increase, so i knew there was a lot to improve.

I realized that just by splitting the set into 2, creating the histograms for both sets and combining the results back into one, i can cut the heavy histogram computation in half (if i run with at least two threads), and thats exactly what i got from my second test with 7.5s Seq and 3.2s Par. Seeing that if i split the set into 4 and doing the same things i can achieve 7.8s Seq and 2s Par, i went all the way to split it into microsets where each set is just one element and run that, but it turned out to be much worse. 40s Seq, 32s Par. Finally, i tried to see the benefits of splitting it into 8 and 16 subsets and i have noticed a drop in performance after going for more subset divisions. For 8 subsets i got 7.5s Seq, 1.5s Par and for 16 i got 7.5s Seq and 1.2s Par.

My next approach is to see what would happen if i go in a different direction. I scatched different approach in `./hist.exalidraw` diagram by splitting the set into microsets of 1 element each to split the work as much as possible, but then i introduced repeated and unnecessery work, for example a lot of 0 + 0 operations, so that will not be the approach to go. One possible optimization is to structure the partial threads into binary tree for reduction sum, but 3x64 < 200 elements to add up, it doesnt speed up things that much to implement it for 3 groups. Maybe for 1000 groups or more that could be a bottleneck, but for now it is not. 

### Benchmark (1 mil, 3 groups):

```
src/histogram/0_naive_hist.bend
Sequential - 10.5s
Paralel    - 6.4s
```
```
src/histogram/1_2way_split_hist.bend:
Sequential - 7.5s
Paralel    - 3.2s
```
```
src/histogram/2_4way_split_hist.bend:
Sequential - 7.87s
Paralel    - 2s
```
```
src/histogram/3_infway_split_hist.bend:
Sequential - 40s
Paralel    - 32s
```
```
src/histogram/4_8way_split_hist.bend:
Sequential - 7.5s
Paralel    - 1.5s
```
```
src/histogram/5_16way_split_hist.bend:
Sequential - 7.5s
Paralel    - 1.2s
```

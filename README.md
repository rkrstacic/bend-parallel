<h1 align=center> Convolution in Parallel </h1>

Convolution is a important operation in mathematics and statistics, widely used in fields such as signal processing, image analysis, and data science. It involves combining two functions to produce a third, expressing how the shape of one is modified by the other. Despite its theoretical simplicity, convolution can be computationally demanding, especially with large datasets.

In statistics, convolution plays a crucial role in probability theory, particularly in the context of adding independent random variables. The computational complexity associated with convolution seek for efficient algorithmic implementations, especially when dealing with large-scale data.

This project explores the benefits of parallel computation for computing convolution operation. The project is built upon Bend programming language, which is a high-level language designed for tapping into parallel computation power by utilizing CPU's multithread architecture or NVIDIA's CUDA api interface for GPUs. 

You can read more about Bend on the [Bend's official GitHub repository](https://github.com/HigherOrderCO/bend/blob/main/GUIDE.md)


# Contents

- [Quick start](#quick-start)
- [Challenges](#challenges)
  - [Histogram](#challenge-1)
  - [Convolution](#challenge-2)

# Quick start (macOS)

Install the Cargo package manager via Rust:
```
curl https://sh.rustup.rs -sSf | sh
```

With Cargo, install the specific versions of the Bend and HVM to ensure the code runs correctly:
```
cargo install hvm@2.0.19
cargo install bend-lang@0.2.36
```

Make sure you have `gcc` installed for parallel execution:
```
brew install gcc
```

Install task runner:
```
brew install go-task
```

To run the code, run in terminal
```
task run
```

### Extra

"Task run" will run the main bend file of the project that is setup as a demonstration.
If you want to run the specific bend file, you can do that by running:
```
bend run <path>
```

You can show the iterations needed, time and the computation speed by adding the `-s` flag at the end of the command:
```
bend run <path> -s
```

To run the code in parallel mode (requires gcc), run:
```
bend run-c <path> -s
```

There are several tasks that can be run:
```
task run                Run the main.bend file
task runc               Run the main.bend file parallelly
task lib-gen            Generate a merged lib file from all the lib files in /src/lib
task benchmark          Run the benchmark on the convolution [64, 128, 256, 512, 1024, 2048, 4096, 8192]
task benchmark-par      Run the benchmark on the convolution with parallel algorithm [64, 128, 256, 512, 1024]
```

# Challenges

These challenges are designed to explore the benefits of parallel computation in Bend. The first challenge is just a warmup challenge to get the feeling of the Bend itself. The second challenge is the main challenge of the convolution computation.

## Challenge 1
> Having an array of numbers create a histogram that counts the number of elements for each range group.

Current personal best: `1.2s` on parallel run

### Background

A histogram is a graphical representation of the distribution of quantitative data. Here, a histogram will be an array of numbers which represent the height of the i-th bar in the histogram. First i wanted to implement histogram in any fashion just to get myself familiar with Bend. This is a good exercise to learn the language before starting to work on anything more complex.

### Approach

My first approach was to store the state of the histogram in map, iterate one element at a time, incrementing different slot depending of the range it falls into and thats it. I got 10s on sequential run (Seq) and 6.5 seconds on parallel run (Par) with c interpreter on M2 chip. From what i have practiced, i have encountered much greater benefits from Par runs than x2 speed increase, so i knew there was a lot to improve.

I realized that just by splitting the set into 2, creating the histograms for both sets and combining the results back into one, i can cut the heavy histogram computation in half (if i run with at least two threads), and thats exactly what i got from my second test with 7.5s Seq and 3.2s Par. Seeing that if i split the set into 4 and doing the same things i can achieve 7.8s Seq and 2s Par, i went all the way to split it into microsets where each set is just one element and run that, but it turned out to be much worse. 40s Seq, 32s Par. Finally, i tried to see the benefits of splitting it into 8 and 16 subsets and i have noticed a drop in performance after going for more subset divisions. For 8 subsets i got 7.5s Seq, 1.5s Par and for 16 i got 7.5s Seq and 1.2s Par.

My next approach is to see what would happen if i go in a different direction. I scatched different approach in `./hist.exalidraw` diagram by splitting the set into microsets of 1 element each to split the work as much as possible, but then i introduced repeated and unnecessery work, for example a lot of 0 + 0 operations, so that will not be the approach to go. One possible optimization is to structure the partial threads into binary tree for reduction sum, but 3x64 < 200 elements to add up, it doesnt speed up things that much to implement it for 3 groups. Maybe for 1000 groups or more that could be a bottleneck, but for now it is not. 

### Benchmark (1 mil, 3 groups):

```
src/histogram/0_naive_hist.bend
Sequential - 10.5s
Parallel   - 6.4s
```
```
src/histogram/1_2way_split_hist.bend:
Sequential - 7.5s
Parallel   - 3.2s
```
```
src/histogram/2_4way_split_hist.bend:
Sequential - 7.87s
Parallel   - 2s
```
```
src/histogram/3_infway_split_hist.bend:
Sequential - 40s
Parallel   - 32s
```
```
src/histogram/4_8way_split_hist.bend:
Sequential - 7.5s
Parallel   - 1.5s
```
```
src/histogram/5_16way_split_hist.bend:
Sequential - 7.5s
Parallel   - 1.2s
```

## Challenge 2
> Compute the convolution of two arrays (same length)

### Background

Having two dice [1-6] each with its set of probabilities, what is probability to get a sum of 7 when rolling both of them? What about a probability for sum of 4? To get all the probabilities of sums 2-12, there is a function called convolution that computes exactly that. More generally, the convolution is the integral of the product of the two functions after one is reflected about the y-axis and shifted. Note: i will be working with discrete numbers. After learning the basics of the bend programming language and playing with the histogram, i was feeling ready to start working on the real problem.

### Approach

The challenge here is to compute the convolution of two arrays having the same length. Even the first version which has no optimizations took some time to implement. Basic idea is to get the all the possible heads and tails, so called "triangles" of first array [a, b, c] => [[a], [a, b], [a, b, c], [b, c], [c]] and of the second array but reversed [z, y, x] => [[z], [z, y], [z, y, x], [y, x], [x]] and then calculate dot product for those with same indices [dot([a], [z]), dot([a, b], [z, y]), ... dot([c], [x])]. If array has n elements, there are 2n - 1 dot products in total. And that's it! The final array of those dot products is an output of the convolution. Compared to challenge 1, that is a lot harder to implement and already at 256 elements for both arrays, the program runs 5.15s Seq and ~1s Par.

From what i have learned, there can be x10 speedup on parallel run, so i immediately started working on that. Since i didnt focus on parallel running, i realized that i could make some room for parallel execution just by computing those dot products in parallel since they are the ones with the most computation and they dont depend on other sets, just the one with the same index. So i have changed things to run on a Tree structure, instead of the List, and checked out how it went. This is where i realized that there were some other things to be fixed before i could get any better time. Unfortunately the way i was implementing some of the function that handle more complex iterators then builtin single array iterator, wsa not optimal. I got 17.55s Seq, and
~6s Par.

After some investigation, i realized that majority of the computation time was coming from sub-optimal implementation of the Tree/from_list function. After i got and alternative solution that used some tricks to get it optimized, i got the time down to 1.77s Seq and 0.75s Par. I got another improvement on that same function and got the time down to 1.53s Seq and 0.65s Par.

I continued the investigation and suspected few more sub-optimal implementations of some other functions. But it wasnt until i went to the source code of the Bend, found golden_tests and then found bunch of .bend test files that taught me how to write better bend. The use of pattern matching for function definition is a thing and it was used a lot. I went to replace the dot product function which i suspected could be improved, and decreased down the time by a lot. With dot product improved the Seq time was 0.32s and Par 0.22s.

Next was, of course, to implement all functions with the new technique of pattern matching and see the results. Once implemented, here are the results of both List based (naive approach) and Tree based (optimized approach) convolution:

256 elements:
List based: 0.12s Seq, 0.06s Par (50.0% speedup)
Tree based: 0.18s Seq, 0.09s Par (50.0% speedup)

512 elements:
List based: 0.46s Seq, 0.24s Par (47.8% speedup)
List based: 0.72s Seq, 0.36s Par (50.0% speedup)

There are few questions that i have to answer. Why is List based approach faster than Tree based approach? Why is the speedup not 90%?

The reason for why List based approach is faster than Tree based approach is because the Tree based approch has an extra layer. It needs to convert the triangles list into a tree structure, and then convert it back to the list. If we analyze the iterations needed for the list based approach we see that the triangles part takes 37% of the computation and 63% is the dot product. The tree based approach has 50% more total workload, and the distribution of the parts is 61% on the triangles part (with tree conversions) and 39% on the dot product part. The triangles part is 22% of the computation, and the tree conversions are 39% of the computation.

The triangles part get a maximum of x4 speedup because the way it is structured, it can be split up into 4 different independent processes. The dot product part on the tree solution has x10 speedup (maximum parallel power). The dot product part of the list solution has x1.4 speedup because the way it is structured. Taking all that into account we get the following:

List based approach:
100% - (37% / 4 + 63% / 1.4) = ~45.8% speedup

Tree based approach:
100% - (39% + 22% / 4 + 39% / 10) = ~51.6% speedup

Tree based solution has a total of 1.61 times more computation to be done


```
Visual representation of the computation:

- T: Tree conversion
- t: triangles
- d: dot product

Sequential
List - tttttttttttttttttttt dddddddddddddddddddddddddddddddddddddddd
Tree - TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT tttttttttttttttttttt dddddddddddddddddddddddddddddddddddddddd  

Parallel
List - ttttt dddddddddddddddddddddddddddd
Tree - TTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTTT ttttt dddddd
```

So, if the Tree conversions are optimized, the tree based approach would be be better than the list based approach by the amount of possible optimization of that tree conversion.

Analyzing the input size and the time needed for completion, we can see that the algorithm time complexity is O(n^2) which is a theoretical time complexity for moving dot products (cross-correlation).

In conclusion, after applying all the techniques i have learned, i have managed to get the time down from 5.15s Seq to 0.12s Seq and from 1.07s Par to 0.06s Par. That is a 43x speedup on sequential run and 15.3x speedup on parallel run.

Possible improvements:
- Implement the tree conversion in a more optimal way for parallel execution


### Benchmark (2 arrays of 256 elements):

```
src/convolution/0_triangle_conv.bend
Sequential - 5.15s
Parallel   - 1.07s
```
```
src/convolution/1_tree_for_parallel.bend:
Sequential - 17.55s
Parallel   - 6.1s
```
```
src/convolution/2_optimized_tree.bend:
Sequential - 1.77s
Parallel   - 0.75s
```
```
src/convolution/3_more_optimized_tree.bend:
Sequential - 1.53s
Parallel   - 0.65s
```
```
src/convolution/4_pattern_matching_for_dotproduct.bend:
Sequential - 0.32s
Parallel   - 0.22s
```
```
src/convolution/5_1_all_pattern_matching_list_based.bend:
Sequential - 0.12s
Parallel   - 0.06s
```

Final results src/convolution/5_1_all_pattern_matching_list_based.bend:
```
Sequential execution
Convolution of arrays size: 64 - 0.01s
Convolution of arrays size: 128 - 0.03s
Convolution of arrays size: 256 - 0.12s
Convolution of arrays size: 512 - 0.46s
Convolution of arrays size: 1024 - 1.80s
Convolution of arrays size: 2048 - 7.47s
Convolution of arrays size: 4096 - 29.57s
Convolution of arrays size: 8192 - Never finished

Parrallel execution
Convolution of arrays size: 64 - 0.01s
Convolution of arrays size: 128 - 0.02s
Convolution of arrays size: 256 - 0.06s
Convolution of arrays size: 512 - 0.23s
Convolution of arrays size: 1024 - 0.90s
Convolution of arrays size: 2048 - 4.16s
Convolution of arrays size: 4096 - Never finished
Convolution of arrays size: 8192 - Never finished
```

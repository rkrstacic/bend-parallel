##
# List Helper functions
#
List.head = @l
  match l {
    List/Cons: l.head
    List/Nil: l
  }

List.tail = @l
  match l {
    List/Cons: l.tail
    List/Nil: l
  }

List.concat = @l1 @l2
  match l1 {
    List/Cons: (List/Cons l1.head (List.concat l1.tail l2))
    List/Nil: l2
  }

List.len = @l
  match l {
    List/Nil: 0
    List/Cons: (+ 1 (List.len l.tail))
  }


##
# Map Helper functions
#
Map.fill.aux = @map @keys @val
  use map = (Map/set map keys val)
  switch keys {
    0: map
    _: (Map.fill.aux map (- keys 1) val)
  }

Map.fill = @keys
  (Map.fill.aux Map/empty keys 0)

def Map.increment(map, key, val):
  curr = map[key]
  
  return Map/set(map, key, curr + val)


## 
# Main
#

get_inc = @el @ranges
  use i = 0
  fold ranges with i {
    List/Cons: if (> el ranges.head) { (ranges.tail (+ i 1)) } else { i }
    List/Nil: i
  }     
      
histogram = @list @ranges
  use ans = (Map.fill (List.len ranges))
  
  fold list with ans {
    List/Cons: (list.tail (Map.increment ans (get_inc list.head ranges) 1))  
    List/Nil: ans   
  }

def map_to_list.aux(map, i, acc):
  switch i:
    case 0:
      return List/Cons(map[acc], List/Nil)
    case _:
      return List/Cons(map[acc], map_to_list.aux(map, i - 1, acc + 1))

map_to_list = @map @i
  (map_to_list.aux map i 0)

data_gen = @n  
  bend x = 0 {
    when (< x n):
      (List/Cons x (fork (+ x 1)))
    else:
      List/Nil  
  }

##
# Benchmark
#
# Sequential
# - ITRS: 515080766
# - TIME: 10.59s
# - MIPS: 48.66
#
# Parallel
# - ITRS: 515080767
# - TIME: 6.40s
# - MIPS: 80.43
#
def main():
  data = data_gen(1_000_000)
  ranges = [200_000, 700_000]
  
  hist = histogram(data, ranges)

  return map_to_list(hist, List.len(ranges))
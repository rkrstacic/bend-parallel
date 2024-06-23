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

List.is_pair.aux = @list @iter
  match list {
    List/Cons: switch iter {
      0: 0
      _: (List.is_pair.aux list.tail (- iter 1))
    }
    List/Nil: switch iter {
      0: 1
      _: 0
    }
  }

List.is_pair = @list
  (List.is_pair.aux list 2)
  
List.to_btree.aux = @l
  match l {
    List/Cons: (List/Cons [l.head, (List.head l.tail)] (List.to_btree.aux (List.tail l.tail)))
    List/Nil: l
  }

List.to_btree = @l
  use btree = (List.to_btree.aux l)
  switch (List.is_pair btree) {
    0: (List.to_btree btree)
    _: btree
  }
  
List.add.aux = @map @l
  use index = 0
  fold l with map, index {
    List/Cons: (l.tail (Map.increment map index l.head) (+ index 1))
    List/Nil: map
  }

def List.add_two_lists(a, b):
  temp = Map.fill(List.len(a))
  temp = List.add.aux(temp, a)
  temp = List.add.aux(temp, b)
  return map_to_list(temp, List.len(a) - 1)

def List.add_all_lists(l):
  len = List.len(List.head(l))
  temp = Map.fill(len)
  
  fold l with temp:
    case List/Cons: 
      temp = List.add.aux(temp, l.head)
      return l.tail(temp)
    case List/Nil:
      return map_to_list(temp, len - 1)


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
  # Map.increment = @map @key @val
  #   (Map/set map key (+ (map[key]) val))
  curr = map[key]
  
  return Map/set(map, key, curr + val)

List.map = @list @fn
  fold list {
    List/Cons: (List/Cons (fn list.head) list.tail)
    List/Nil: List/Nil   
  }


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

def map_to_list(map, i):
  return map_to_list.aux(map, i, 0)

def data_gen(n, offset):
  bend x = 0:
    when x < n:
      data = List/Cons(x + offset, fork(x + 1))
    else:
      data = List/Nil
  
  return data

def data_gen_n_arrays(num_of_elements, num_of_arrays):
  use sub_array_size = num_of_elements / num_of_arrays
  bend x = 0:
    when x < num_of_arrays:
      return List/Cons(data_gen(sub_array_size, x * sub_array_size), fork(x + 1))
    else:
      return List/Nil

##
# Benchmark
#
# Sequential
# - ITRS: 406815361
# - TIME: 7.55s
# - MIPS: 53.89
#
# Parallel
# - ITRS: 406912578
# - TIME: ~1.1s
# - MIPS: 366.29
def main():
  data = data_gen_n_arrays(1_000_000, 64)
  ranges = [200_000, 700_000]

  fn = lambda el: map_to_list(histogram(el, ranges), List.len(ranges))

  partial_hists = List.map(data, fn)
  return List.add_all_lists(partial_hists)

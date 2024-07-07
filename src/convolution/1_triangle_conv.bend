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

List.sum = @l
  match l {
    List/Cons: (+ l.head (List.sum l.tail))
    List/Nil: 0
  }

List.fsum = @l
  match l {
    List/Cons: (+ l.head (List.fsum l.tail))
    List/Nil: 0.0
  }

List.reverse.aux = @acc @l
  match l {
    List/Nil: acc
    List/Cons: (List.reverse.aux (List/Cons l.head acc) l.tail)
  }
List.reverse = @l
  (List.reverse.aux [] l)

List.map = @list @fn
  fold list {
    List/Cons: (List/Cons (fn list.head) list.tail)
    List/Nil: List/Nil   
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
  # Map.increment = @map @key @val
  #   (Map/set map key (+ (map[key]) val))
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

def map_to_list(map, i):
  return map_to_list.aux(map, i, 0)

data_gen = @n
  bend x = 0 {
    when (< x n):
      (List/Cons x (fork (+ x 1)))
    else:
      List/Nil
  }

data_gen2 = @n
  bend x = 0 {
    when (< x n):
      (List/Cons 2 (fork (+ x 1)))
    else:
      List/Nil
  }



# 1, 2, 3, 4 => [1], [1, 2], [1, 2, 3], [1, 2, 3, 4], [2, 3, 4], [3, 4], [4]
# tails      => [1, 2, 3, 4], [2, 3, 4], [3, 4], [4]
# heads      => [1], [2, 1], [3, 2, 1], [4, 3, 2, 1]
# tails(arr) = tails
# heads(arr) = tails(reverse(arr))
# triangle   => [1, 2, 3, 4], [2, 3, 4], [3, 4], [4], [1], [2, 1], [3, 2, 1]

# Returns tails of reversed list
List.reversed.tails.aux = @arr @acc
  match arr {
    List/Cons: (List/Cons acc (List.reversed.tails.aux arr.tail (List/Cons arr.head acc)))
    List/Nil: []
  }

List.reversed.tails = @arr
  (List.reversed.tails.aux (List.tail arr) [(List.head arr)])

List.tails = @arr
  match arr {
    List/Cons: (List/Cons arr (List.tails arr.tail))
    List/Nil: []
  }

List.triangle = @arr 
  (List.concat (List.map (List.reversed.tails arr) List.reverse) (List.tails arr))

# Applies a binary function to first elements of two lists, then to second elements, etc.
List.zip_with = @f @arr1 @arr2
  fold arr1 with arr2 {
    List/Cons: (List/Cons (f arr1.head (List.head arr2)) (arr1.tail (List.tail arr2)))
    List/Nil: List/Nil
  }

# Dot product of two lists
List.dot = @arr1 @arr2
  (List.sum (List.zip_with (@x @y (* x y)) arr1 arr2))

# Dot product of two lists (floating point)
List.fdot = @arr1 @arr2
  (List.fsum (List.zip_with (@x @y (* x y)) arr1 arr2))

List.convolve = @arr1 @arr2
  (List.zip_with List.dot (List.triangle arr1) (List.reverse (List.triangle (List.reverse arr2))))
 
List.fconvolve = @arr1 @arr2
  (List.zip_with List.fdot (List.triangle arr1) (List.reverse (List.triangle (List.reverse arr2))))

##
# Benchmark 256
#
# Sequential
# - ITRS: 322356495
# - TIME: 5.15s
# - MIPS: 62.59
#
# Parallel
# - ITRS: 322356495
# - TIME: 1.07s
# - MIPS: 301.40
def main():
  data1 = data_gen(256)
  data2 = data_gen(256)
  return List.len(List.convolve(data1, data2))

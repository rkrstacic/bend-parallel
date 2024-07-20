#
# Included Library
#

###########################################
### Singly-Linked List Type Definition: ###

# The List type is builtin, so we don't need to declare it.
# But this is how it's defined in the builtins file.
# type List:
#   Nil
#   Cons { head, ~tail }

# List of functions:
# - List/add_front
# - List/append
# - List/clear
# - List/concat
# - List/convolve
# - List/count
# - List/create
# - List/dot
# - List/dot/with.Tree
# - List/fconvolve
# - List/fdot
# - List/fsum
# - List/head
# - List/index
# - List/is_pair
# - List/is_single
# - List/len
# - List/map
# - List/pop_back
# - List/pop_front
# - List/remove
# - List/reverse
# - List/reversed_tails
# - List/split
# - List/sum
# - List/tail
# - List/tails
# - List/to_btree
# - List/triangle
# - List/zip_with


###########################################
#
#
# List add_front:
#   adds a non-List element to the front of list.
# Example:
#   [2, 3], 1 -> [1, 2, 3]
List/add_front = @l @e
  match l {
    List/Cons: (List/Cons e l)
    List/Nil: (List/Cons e List/Nil)
  }

#
#
# List append (add_back):
#   adds a non-list element to the back of list.
# Example:
#   [1, 2], 3 -> [1, 2, 3]
List/append = @l @e
  (List/concat l (List/Cons e List/Nil))

#
#
# List clear:
#   clears all elements from list l. This is equivalent to initializing an empty list.
# Example:
#   [0, 2, 3] -> []
List/clear = @l
  []

#
#
# List concat:
#   combines two lists from left to right.
# Example:
#   [1, 2], [3, 4] -> [1, 2, 3, 4]
# List/concat = @l1 @l2
#   match l1 {
#     List/Cons: (List/Cons l1.head (List/concat l1.tail l2))
#     List/Nil: l2
#   }

#
#
# List convolve:
#   Convolution of two lists
# Example:
#   [1, 2, 3, 4], [1, 2, 3, 4] -> [1, 4, 10, 20, 25, 24, 16]
List/convolve = @arr1 @arr2
  (List/zip_with List/dot (List/triangle arr1) (List/reverse (List/triangle (List/reverse arr2))))
  

#
#
# List create:
#   creates a list of n elements, all with the same value.
# Example:
#   3, 4 -> [4, 4, 4]
List/create = @n @val
  bend x = 0 {
    when (< x n):
      (List/Cons val (List/create (- n 1) val))
    else:
      List/Nil
  }

#
#
# List count:
#   returns the number of instances of some value in the list.
# Example:
#   [1, 2, 3, 3, 3, 4, 4, 5, 3, 1000], 4 -> 2
List/count/aux = @acc @l @s
  match l {
    List/Nil: acc
    List/Cons: use acc = switch (== l.head s) {
      0: acc;
      _: (+ acc 1);
    }
    (List/count/aux acc l.tail s)
  }

List/count = @l @s
  (List/count/aux 0 l s)

#
#
# List dot:
#   Dot product of two lists
# Example:
#   [1, 2, 3, 4], [1, 2, 3, 4] -> 30
List/dot = @arr1 @arr2
  (List/sum (List/zip_with (@x @y (* x y)) arr1 arr2))

#
#
# List dot with Tree:
#   Dot product of two lists with Tree
# Example:
#   [1, 2, 3, 4], [1, 2, 3, 4] -> 30
List/dot/with.Tree = @l1 @l2
  use t1 = (Tree/from_list l1)
  use t2 = (Tree/from_list l2)
  (Tree/to_list (Tree/sum (Tree/zip_with Number/mul t1 t2)))

#
#
# List fconvolve:
#   Convolution of two lists (with floating points)
# Example:
#   [0.1, 0.2, 0.3, 0.4], [0.1, 0.2, 0.3, 0.4] -> [0.01, 0.04, 0.1, 0.2, 0.2, 0.25, 0.24, 0.16]
List/fconvolve = @arr1 @arr2
  (List/zip_with List/fdot (List/triangle arr1) (List/reverse (List/triangle (List/reverse arr2))))

#
#
# List dot (with floating points):
#   Dot product of two lists
# Example:
#  [0.1, 0.2, 0.3, 0.4], [0.1, 0.2, 0.3, 0.4] -> 0.3
List/fdot = @arr1 @arr2
  (List/fsum (List/zip_with (@x @y (* x y)) arr1 arr2))

#
#
# List fsum (with floating points):
#   returns the sum of all items in the list.
# Example:
#   [0.1, 0.2, 0.3] -> 0.6
List/fsum = @l
  match l {
    List/Cons: (+ l.head (List/fsum l.tail))
    List/Nil: 0.0
  }

#
#
# List head:
#   Returns the first item in the list, or [] if the list is empty.
# Example:
#   [1, 2, 3] -> 1
List/head = @l
  match l {
    List/Cons: l.head
    List/Nil: []
  }

#
#
# List index:
#   returns the value at specified index of a list, or * if the index doesn't exist.
# Example:
#   [5, 3, 6, 8, 2], 0 -> 5
#   [5, 3, 6, 8, 2], 3 -> 8
#   [5, 3, 6, 8, 2], 5 -> *
List/index = @l @i
  match l {
    List/Cons: 
      switch i {
        0: l.head
        _: (List/index l.tail (i-1))
      }
    List/Nil: *
  }

#
#
# List is pair:
#   Checks if list has a length of 2 (with early return).
# Example:
#   [1] -> 0
#   [1, 2] -> 1
#   [1, 2, 3] -> 0
List/is_pair/aux = @list @iter
  match list {
    List/Cons: switch iter {
      0: 0
      _: (List/is_pair/aux list.tail (- iter 1))
    }
    List/Nil: switch iter {
      0: 1
      _: 0
    }
  }

List/is_pair = @list
  (List/is_pair/aux list 2)

#
#
# List is single:
#   Checks if list has a length of 1 (with early return).
# Example:
#   [1] -> 1
#   [1, 2] -> 0
List/is_single = @list
  (List/is_pair/aux list 1)

#
#
# List length:
#   returns the number of elements in list
# Example:
#   [1, 2, 3, 4, 4, 4] -> 6
List/len = @l
  match l {
    List/Nil: 0
    List/Cons: (+ 1 (List/len l.tail))
  }

#
#
# List map:
#   Applies a function to each element of the list
# Example:
#   [1, 2, 3, 4, 5], (fn (x) => x + 1) -> [2, 3, 4, 5, 6]
List/map = @list @fn
  fold list {
    List/Cons: (List/Cons (fn list.head) list.tail)
    List/Nil: List/Nil   
  }

#
#
# List pop back:
#   Removes and discards the the last item of list l.
# Example:
#   [1, 2, 3, 4] -> [1, 2, 3]
List/pop_back (List/Nil) = List/Nil
List/pop_back (List/Cons x List/Nil) = List/Nil
List/pop_back (List/Cons head tail) = (List/Cons head (List/pop_back tail))  
#
#
# List pop front: 
#   Removes and discards the first item of list l.
#   The new list is returned, or [] if the list is empty.
# Example:
#   [1, 2, 3] -> [2, 3]
List/pop_front = @l
  match l {
    List/Cons: l.tail
    List/Nil: []
  }

#
#
# List remove:
#   Removes the first occurence of element e from list l.
# Example:
#   [1, 2, 1, 3], 1 -> [2, 1, 3]
List/remove = @l @s
  match l {
    List/Cons:
      switch (== l.head s) {
        0: (List/Cons l.head (List/remove l.tail s))
        _: l.tail
      }
    List/Nil: List/Nil
  }

#
#
# List reverse:
#   reverses the order of elements in list.
# Example:
#   [1, 2, 3, 4, 5] -> [5, 4, 3, 2, 1]
# List/reverse/aux = @acc @l
#   match l {
#     List/Nil: acc
#     List/Cons: (List/reverse/aux (List/Cons l.head acc) l.tail)
#   }
# List/reverse = @l
#   (List/reverse/aux [] l)

#
#
# List reversed tails:
#   Returns an array of all tails of reversed list except the full array
#   Mostly used for convolution
# Example:
#   [1, 2, 3, 4] -> [[1], [2, 1], [3, 2, 1]]
List/reversed_tails/aux = @arr @acc
  match arr {
    List/Cons: (List/Cons acc (List/reversed_tails/aux arr.tail (List/Cons arr.head acc)))
    List/Nil: []
  }

List/reversed_tails = @arr
  (List/reversed_tails/aux (List/tail arr) [(List/head arr)])

#
#
# List split:
#   Splits list l into two lists (l1, l2) at index i.
#   the second list takes the element at index i during the split.
# Example:
#   [1, 2, 3, 4, 5, 6, 7], 3 -> ([1, 2, 3], [4, 5, 6, 7])
List/split/aux = @acc @l @i
  match l {
    List/Cons: 
      switch i {
        0: (acc, l)
        _: (List/split/aux (List/append acc l.head) l.tail i-1)
      }
    List/Nil: *
  }
List/split = @l @i
  (List/split/aux [] l i)

#
#
# List sum:
#   returns the sum of all items in the list.
# Example:
#   [1, 2, 3] -> 6 
List/sum = @l
  match l {
    List/Cons: (+ l.head (List/sum l.tail))
    List/Nil: 0
  }

#
#
# List tail:
#   Returns the list without the first element, or [] if the list is empty.
# Example:
#   [1, 2, 3] -> [2, 3]
List/tail = @l
  match l {
    List/Cons: l.tail
    List/Nil: l
  }
#
#
# List tails:
#   Returns an array of all tails of list
# Example:
#   [1, 2, 3, 4] -> [[1, 2, 3, 4], [2, 3, 4], [3, 4], [4], []]
List/tails = @arr
  match arr {
    List/Cons: (List/Cons arr (List/tails arr.tail))
    List/Nil: []
  }

#
#
# List to btree:
#   groups elements into binary tree list. 
# Example:
#   [1, 2, 3, 4, 5] -> [[[1, 2], [3, 4]], [[5, []], [[], []]]
List/to_btree/aux = @l
  match l {
    List/Cons: (List/Cons [l.head, (List/head l.tail)] (List/to_btree/aux (List/tail l.tail)))
    List/Nil: l
  }

List/to_btree = @l
  use btree = (List/to_btree/aux l)
  switch (List/is_pair btree) {
    0: (List/to_btree btree)
    _: btree
  }

#
#
# List triangle (not exactly):
#   Returns an array of all triangles of list (not exactly, but it's enough for convolution)
#   The tails part is reversed, so it's not exactly a triangle
# Example:
#   [1, 2, 3, 4] -> [[1], [1, 2], [1, 2, 3], [1, 2, 3, 4], []
List/triangle = @arr 
  (List/concat (List/map (List/reversed_tails arr) List/reverse) (List/tails arr))

#
#
# List zip with:
#   Applies a binary function to first elements of two lists, then to second elements, etc.
# Example:
#   (fn (x, y) => x * y), [1, 2, 3, 4], [1, 2, 3, 4] -> [1, 4, 9, 16]
List/zip_with = @fn @arr1 @arr2
  fold arr1 with arr2 {
    List/Cons: (List/Cons (fn arr1.head (List/head arr2)) (arr1.tail (List/tail arr2)))
    List/Nil: List/Nil
  }

#################################

# Example usage of the functions above:
# def main:
#  return List/add_front([2, 3], 1)
#  return List/append([1, 2], 3)
#  return List/clear([0, 2, 3])
#  return List/concat([1, 2], [3, 4])
#  return List/convolve([1, 2, 3, 4], [1, 2, 3, 4])
#  return List/count([1, 2, 3, 3, 3, 4, 4, 5, 3, 1000], 4)
#  return List/create(3, 4)
#  return List/dot([1, 2, 3, 4], [1, 2, 3, 4])
#  return List/dot/with.Tree([1, 2, 3, 4], [1, 2, 3, 4])
#  return List/fconvolve([0.1, 0.2, 0.3, 0.4], [0.1, 0.2, 0.3, 0.4])
#  return List/fdot([0.1, 0.2, 0.3, 0.4], [0.1, 0.2, 0.3, 0.4])
#  return List/fsum([0.1, 0.2, 0.3])
#  return List/head([1, 2, 3])
#  return List/index([5, 3, 6, 8, 2], 0)
#  return List/index([5, 3, 6, 8, 2], 3)
#  return List/index([5, 3, 6, 8, 2], 5)
#  return List/is_pair([1])
#  return List/is_pair([1, 2])
#  return List/is_pair([1, 2, 3])
#  return List/is_single([1])
#  return List/is_single([1, 2])
#  return List/len([1, 2, 3, 4, 4, 4])
#  return List/map([1, 2, 3, 4, 5], (lambda x: x + 1))
#  return List/pop_back([1, 2, 3, 4])
#  return List/pop_front([1, 2, 3])
#  return List/remove([1, 2, 1, 3], 1)
#  return List/reverse([1, 2, 3, 4, 5])
#  return List/reversed_tails([1, 2, 3, 4])
#  return List/split([1, 2, 3, 4, 5, 6, 7], 3)
#  return List/sum([1, 2, 3])
#  return List/tail([1, 2, 3])
#  return List/tails([1, 2, 3, 4])
#  return List/to_btree([1, 2, 3, 4, 5])
#  return List/triangle([1, 2, 3, 4])
#  return List/zip_with((lambda x, y: x * y), [1, 2, 3, 4], [1, 2, 3, 4])
###########################################
### Map

# The Map type is builtin, so we don't need to declare it.
# But this is how it's defined in the builtins file.
# type Map:
#   Node { value ~left ~right }
#   Leaf

# Built-in functions:
# Map/empty: -> Map
# Map/set: Map -> uint -> uint -> Map
# Map/get: Map -> uint -> uint

###########################################
#
#
# Map increment:
#   Increments the value of a key in the map.
# Example:
#   {0: 1, 1: 2}, 1, 1 -> {0: 1, 1: 3}
def Map/increment(map, key, val):
  curr = map[key]
  
  return Map/set(map, key, curr + val)

#
#
# Map fill:
#   Creates a map with keys from 0 to n - 1, with value of 0.
# Example:
#   3 -> {0: 0, 1: 0, 2: 0}
Map/fill/aux = @map @keys @val
  use map = (Map/set map keys val)
  switch keys {
    0: map
    _: (Map/fill/aux map (- keys 1) val)
  }

Map/fill = @keys
  (Map/fill/aux Map/empty keys 0)

#################################

# Example usage of the functions above:
# def main:
  # return Map/fill(3)
  # return Map/increment({0: 1, 1: 2}, 1, 1)
Number/next_power_of_two/aux = @n @x
  if (> (+ x 1) n) {
    x
  } else {
    (Number/next_power_of_two/aux n (* x 2))
  }

Number/next_power_of_two = @n
  (Number/next_power_of_two/aux n 1)

Number/needed_for_power_of_two = @n
  (- (Number/next_power_of_two n) n)

Number/mul = @x @y
  (* x y)
# type Tree:
#   Node { ~left, ~right }
#   Leaf { value }

Tree/generate = @depth
  bend x = 0 {
    when (< x depth):
      (Tree/Node (fork (+ x 1)) (fork (+ x 1)))
    else:
      (Tree/Leaf x)
  }

Tree/to_list = @tree
  match tree {
    Tree/Node: (List/concat (Tree/to_list tree.left) (Tree/to_list tree.right))  
    Tree/Leaf: (List/Cons tree.value [])
  }

Tree/left = @tree
  match tree {
    Tree/Node: tree.left
    Tree/Leaf: tree
  }

Tree/right = @tree
  match tree {
    Tree/Node: tree.right
    Tree/Leaf: tree
  }

Tree/value = @tree
  match tree {
    Tree/Node: 0
    Tree/Leaf: tree.value
  }

Tree/zip_with = @fn @tree1 @tree2
  fold tree1 with tree2 {
    Tree/Node: (Tree/Node (tree1.left (Tree/left tree2)) (tree1.right (Tree/right tree2)))
    Tree/Leaf: (Tree/Leaf (fn tree1.value (Tree/value tree2)))
  }

# TODO: Optimize this function
Tree/from_list/aux/new_layer = @l
  match l {
    List/Cons: (List/Cons (Tree/Node l.head (List/head l.tail)) (Tree/from_list/aux/new_layer (List/tail l.tail)))
    List/Nil: List/Nil
  }

Tree/from_list/aux = @l
  use btree = (Tree/from_list/aux/new_layer l)
  switch (List/is_single btree) {
    0: (Tree/from_list/aux btree)
    _: btree
  }

Tree/from_list = @l
  use mapped = (List/map l (@x (Tree/Leaf x)))
  use extenstion = (List/create (Number/needed_for_power_of_two (List/len l)) (Tree/Leaf 0))
  (List/head (Tree/from_list/aux (List/concat mapped extenstion)))

Tree/from_list_val = @l @val
  use mapped = (List/map l (@x (Tree/Leaf x)))
  use extenstion = (List/create (Number/needed_for_power_of_two (List/len l)) (Tree/Leaf val))
  (List/head (Tree/from_list/aux (List/concat mapped extenstion)))

Tree/sum = @tree
  fold tree {
    Tree/Node: (+ (tree.left) (tree.right))
    Tree/Leaf: tree.value
  }

#
# End of included library
#



# ## 
# # Main
# #

get_inc = @el @ranges
  use i = 0
  fold ranges with i {
    List/Cons: if (> el ranges.head) { (ranges.tail (+ i 1)) } else { i }
    List/Nil: i
  }
     
      
histogram = @list @ranges
  use ans = (Map/fill (List/len ranges))
  
  fold list with ans {
    List/Cons: (list.tail (Map/increment ans (get_inc list.head ranges) 1))  
    List/Nil: ans   
  }

def map_to_list/aux(map, i, acc):
  switch i:
    case 0:
      return List/Cons(map[acc], List/Nil)
    case _:
      return List/Cons(map[acc], map_to_list/aux(map, i - 1, acc + 1))

def map_to_list(map, i):
  return map_to_list/aux(map, i, 0)

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

# Tree/dot = @tree1 @tree2
#   (Tree/sum (Tree/zip_with Number/mul tree1 tree2))

List/convolve/with.Tree = @l1 @l2
  use t1 = (Tree/from_list_val (List/triangle l1) [0])
  use t2 = (Tree/from_list_val (List/reverse (List/triangle (List/reverse l2))) [0])
  (Tree/to_list (Tree/zip_with List/dot t1 t2))
  

##
# Benchmark 256
#
# Sequential
# - ITRS: 1061249496
# - TIME: 17.55s
# - MIPS: 60.47

# Parallel
# - ITRS: 1061249496
# - TIME: 6.11s
# - MIPS: 162.17

# Tree approach is not optimized
# Specifically, the Tree/from_list/aux/new_layer function
# That function calls List/head(l.tail) which is O(n) for each element

main =
  use data1 = (data_gen 256)
  use data2 = (data_gen 256)
  (List/len (List/convolve/with.Tree data1 data2))

#########################################################
### Singly-Linked List Type Definition and functions: ###
#
#
# The List type is builtin, so we don't need to declare it.
# But this is how it's defined in the builtins file.
# type List:
#   Nil
#   Cons { head, ~tail }
#
# List of functions in this file:
# - List/add_front
# - List/append
# - List/clear 
# - List/concat (builtin)
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
# - List/reverse (builtin)
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
# List/add_front:
#   adds a non-List element to the front of list.
# Example:
#   [2, 3], 1 -> [1, 2, 3]
List/add_front (List/Cons x xs) el = (List/Cons el (List/Cons x xs))
List/add_front [] el = (List/Cons el List/Nil)

#
#
# List/append (add_back):
#   adds a non-list element to the back of list.
# Example:
#   [1, 2], 3 -> [1, 2, 3]
List/append l e = (List/concat l (List/Cons e List/Nil))

#
#
# List/clear:
#   clears all elements from list l. This is equivalent to initializing an empty list.
# Example:
#   [0, 2, 3] -> []
List/clear l = []

#
#
# <builtin>
# List/concat:
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
# List/convolve:
#   Convolution of two lists
# Example:
#   [1, 2, 3, 4], [1, 2, 3, 4] -> [1, 4, 10, 20, 25, 24, 16]
List/convolve arr1 arr2 = (List/zip_with List/dot (List/triangle arr1) (List/reverse (List/triangle (List/reverse arr2))))

#
#
# List/convolve/with.Tree:
#   Convolution of two lists with Tree implementation
# Example:
#   [1, 2, 3, 4], [1, 2, 3, 4] -> [1, 4, 10, 20, 25, 24, 16, 0]
List/convolve/with.Tree l1 l2 = (Tree/to_list (Tree/zip_with List/dot (Tree/from_list_val (List/triangle l1) [0]) (Tree/from_list_val (List/reverse (List/triangle (List/reverse l2))) [0])))

#
#
# List/create:
#   creates a list of n elements, all with the same value.
# Example:
#   3, 4 -> [4, 4, 4]
List/create n val = if (> n 0) { (List/Cons val (List/create (- n 1) val)) } else { List/Nil }


#
#
# List/count:
#   returns the number of instances of some value in the list.
# Example:
#   [1, 2, 3, 3, 3, 4, 4, 5, 3, 1000], 4 -> 2
List/count/aux acc (List/Cons l xl) s = (List/count/aux (if (== l s) { (+ acc 1) } else { acc }) xl s)
List/count/aux acc [] s = acc

List/count l s = (List/count/aux 0 l s)

#
#
# List/dot:
#   Dot product of two lists
# Example:
#   [1, 2, 3, 4], [1, 2, 3, 4] -> 30
List/dot arr1 arr2 = (List/sum (List/zip_with (@x @y (* x y)) arr1 arr2))

#
#
# List/dot/with.Tree:
#   Dot product of two lists with Tree
# Example:
#   [1, 2, 3, 4], [1, 2, 3, 4] -> 30
List/dot/with.Tree = @l1 @l2
  use t1 = (Tree/from_list l1)
  use t2 = (Tree/from_list l2)
  (Tree/to_list (Tree/sum (Tree/zip_with (@x @y (* x y)) t1 t2)))

#
#
# List/fconvolve:
#   Convolution of two lists (with floating points)
# Example:
#   [0.1, 0.2, 0.3, 0.4], [0.1, 0.2, 0.3, 0.4] -> [0.01, 0.04, 0.1, 0.2, 0.2, 0.25, 0.24, 0.16]
List/fconvolve arr1 arr2 = (List/zip_with List/fdot (List/triangle arr1) (List/reverse (List/triangle (List/reverse arr2))))

#
#
# List/dot:
#   Dot product of two lists (with floating points)
# Example:
#  [0.1, 0.2, 0.3, 0.4], [0.1, 0.2, 0.3, 0.4] -> 0.3
List/fdot arr1 arr2 = (List/fsum (List/zip_with (@x @y (* x y)) arr1 arr2))

#
#
# List/fsum:
#   returns the sum of all items in the list (with floating points)
# Example:
#   [0.1, 0.2, 0.3] -> 0.6
List/fsum (List/Cons l xl) = (+ l (List/fsum xl))
List/fsum [] = 0.0

#
#
# List/head:
#   Returns the first item in the list, or [] if the list is empty.
# Example:
#   [1, 2, 3] -> 1
List/head (List/Cons x xs) = x
List/head [] = []

#
#
# List/index:
#   returns the value at specified index of a list, or * if the index doesn't exist.
# Example:
#   [5, 3, 6, 8, 2], 0 -> 5
#   [5, 3, 6, 8, 2], 3 -> 8
#   [5, 3, 6, 8, 2], 5 -> *
List/index (List/Cons x xs) 0 = x
List/index (List/Cons x xs) n = (List/index xs (- n 1))
List/index [] n = *

#
#
# List/is_pair:
#   Checks if list has a length of 2 (with early return).
# Example:
#   [1] -> 0
#   [1, 2] -> 1
#   [1, 2, 3] -> 0
List/is_pair/aux (List/Cons x xs) 0 = 0
List/is_pair/aux [] 0 = 1
List/is_pair/aux [] n = 0
List/is_pair/aux (List/Cons x xs) n = (List/is_pair/aux xs (- n 1))

List/is_pair list = (List/is_pair/aux list 2)

#
#
# List/is_single:
#   Checks if list has a length of 1 (with early return).
# Example:
#   [1] -> 1
#   [1, 2] -> 0
List/is_single list = (List/is_pair/aux list 1)

#
#
# List/len:
#   returns the number of elements in list
# Example:
#   [1, 2, 3, 4, 4, 4] -> 6
List/len/aux [] count = count
List/len/aux (List/Cons x xs) count = (List/len/aux xs (+ count 1))

List/len list = (List/len/aux list 0)

#
#
# List/map:
#   Applies a function to each element of the list
# Example:
#   [1, 2, 3, 4, 5], (fn (x) => x + 1) -> [2, 3, 4, 5, 6]
List/map [] fn = List/Nil
List/map (List/Cons x xs) fn = (List/Cons (fn x) (List/map xs fn))

#
#
# List/pop_back:
#   Removes and discards the the last item of list l.
# Example:
#   [1, 2, 3, 4] -> [1, 2, 3]
List/pop_back (List/Nil) = List/Nil
List/pop_back (List/Cons x List/Nil) = List/Nil
List/pop_back (List/Cons x xs) = (List/Cons x (List/pop_back xs))  

#
#
# List/pop_front: 
#   Removes and discards the first item of list l.
#   The new list is returned, or [] if the list is empty.
# Example:
#   [1, 2, 3] -> [2, 3]
List/pop_front (List/Cons x xs) = xs
List/pop_front [] = []

#
#
# List/remove:
#   Removes the first occurence of element e from list l.
# Example:
#   [1, 2, 1, 3], 1 -> [2, 1, 3]
List/remove (List/Cons x xs) s = (if (== x s) { xs } else { (List/Cons x (List/remove xs s)) })
List/remove [] s = []

#
#
# <builtin>
# List/reverse:
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
# List/reversed_tails:
#   Returns an array of all tails of reversed list except the full array
#   Mostly used for convolution
# Example:
#   [1, 2, 3, 4] -> [[1], [2, 1], [3, 2, 1]]
List/reversed_tails/aux [] acc = []
List/reversed_tails/aux (List/Cons x xs) acc = (List/Cons acc (List/reversed_tails/aux xs (List/Cons x acc)))

List/reversed_tails [] = []
List/reversed_tails (List/Cons x xs) = (List/reversed_tails/aux xs [x])

#
#
# List/split:
#   Splits list l into two lists (l1, l2) at index i.
#   the second list takes the element at index i during the split.
# Example:
#   [1, 2, 3, 4, 5, 6, 7], 3 -> ([1, 2, 3], [4, 5, 6, 7])
List/split/aux acc [] i = *
List/split/aux acc (List/Cons x xs) 0 = (acc, (List/Cons x xs))
List/split/aux acc (List/Cons x xs) i = (List/split/aux (List/append acc x) xs (- i 1))

List/split l i = (List/split/aux [] l i)

#
#
# List/sum:
#   returns the sum of all items in the list.
# Example:
#   [1, 2, 3] -> 6 
List/sum [] = 0
List/sum (List/Cons x xs) = (+ x (List/sum xs))

#
#
# List/tail:
#   Returns the list without the first element, or [] if the list is empty.
# Example:
#   [1, 2, 3] -> [2, 3]
List/tail (List/Cons x xs) = xs
List/tail [] = []

#
#
# List/tails:
#   Returns an array of all tails of list
# Example:
#   [1, 2, 3, 4] -> [[1, 2, 3, 4], [2, 3, 4], [3, 4], [4], []]
List/tails [] = []
List/tails (List/Cons x xs) = (List/Cons (List/Cons x xs) (List/tails xs))

#
#
# List/to_btree:
#   groups elements into binary tree list. 
# Example:
#   [1, 2, 3, 4, 5] -> [[[1, 2], [3, 4]], [[5, []], [[], []]]
List/to_btree/aux [] = []
List/to_btree/aux (List/Cons x List/Nil) = (List/Cons [x, *] List/Nil)
List/to_btree/aux (List/Cons x (List/Cons y ys)) = (List/Cons [x, y] (List/to_btree/aux ys))

List/to_btree l = if (List/is_pair l) { (l) } else { (List/to_btree (List/to_btree/aux l)) }

#
#
# List/triangle: (not exactly)
#   Returns an array of all triangles of list (not exactly, but it's enough for convolution)
#   The tails part is reversed, so it's not exactly a triangle
# Example:
#   [1, 2, 3, 4] -> [[1], [1, 2], [1, 2, 3], [1, 2, 3, 4], []
List/triangle arr = (List/concat (List/map (List/reversed_tails arr) List/reverse) (List/tails arr))

#
#
# List/zip_with:
#   Applies a binary function to first elements of two lists, then to second elements, etc.
# Example:
#   (fn (x, y) => x * y), [1, 2, 3, 4], [1, 2, 3, 4] -> [1, 4, 9, 16]
List/zip_with fn [] [] = List/Nil
List/zip_with fn [] (List/Cons x xs) = *
List/zip_with fn (List/Cons x xs) [] = *
List/zip_with fn (List/Cons x xs) (List/Cons y ys) = (List/Cons (fn x y) (List/zip_with fn xs ys))


#################################
# Example usage of the functions above:
# def main:
#  return List/add_front([2, 3], 1) == [1, 2, 3]
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
#  return List/map([[1], [2], [3], [4], [5], [6], [7], [8], [9], [10]], List/sum)
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
#  return List/triangle([1, 2, 3, 4, 5, 6, 7])
#  return List/zip_with((lambda x, y: x * y), [1, 2, 3, 4], [1, 2, 3, 4])
################################
### Number helper functions: ###
#
#
# List of functions in this file:
# - Number/next_power_of_two
# - Number/needed_for_power_of_two
# - Number/mul
# - Number/log2/int


###########################################
#
#
# Number/next_power_of_two:
#   returns the next power of two greater than n.
# Example:
#   5 -> 8
#   8 -> 8
#   9 -> 16
Number/next_power_of_two/aux n x = if (> (+ x 1) n) { x } else { (Number/next_power_of_two/aux n (* x 2)) }

Number/next_power_of_two n = (Number/next_power_of_two/aux n 1)

#
#
# Number/needed_for_power_of_two:
#   returns the number needed to reach the next power of two.
# Example:
#   5 -> 3
#   8 -> 0
#   9 -> 7
Number/needed_for_power_of_two n = (- (Number/next_power_of_two n) n)

#
#
# Number/mul:
#   returns the product of x and y.
# Example:
#   5 3 -> 15
#   8 8 -> 64
Number/mul x y = (* x y)

#
#
# Number/log2/int:
#   returns the integer part of the base 2 logarithm of n.
# Example:
#   5 -> 2
#   8 -> 3
#   9 -> 3
Number/log2/int/aux 0 acc = acc
Number/log2/int/aux n acc = (Number/log2/int/aux (/ n 2) (+ acc 1))

Number/log2/int n = (Number/log2/int/aux (- n 1) 0)


############################################
# Example usage of the functions above:
# main =
#   (Number/next_power_of_two 5)
#   (Number/needed_for_power_of_two 5)
#   (Number/mul 5 3)
#   (Number/log2/int 5)
#################################################
### Tree Type Definition and Helper functions ###
#
#
# The Tree type is builtin, so we don't need to declare it.
# But this is how it's defined in the builtins file.
# type Tree
#   Node (Tree left) (Tree right)
#   Leaf Number
#
# List of functions in this file:
# - Tree/generate
# - Tree/to_list
# - Tree/left
# - Tree/right
# - Tree/value
# - Tree/zip_with
# - Tree/from_list
# - Tree/from_list_val
# - Tree/sum
# - Tree/len


################################
#
#
# Tree/generate:
#   generates a tree of depth depth.
# Example:
#   3 -> (Node (Node (Leaf 3) (Leaf 3)) (Node (Leaf 3) (Leaf 3))
Tree/generate = @depth
  bend x = 0 {
    when (< x depth):
      (Tree/Node (fork (+ x 1)) (fork (+ x 1)))
    else:
      (Tree/Leaf x)
  }

#
#
# Tree/to_list:
#   returns a list of the values in the tree.
# Example:
#   (Node (Node (Leaf 3) (Leaf 5)) (Node (Leaf 8) (Leaf 3))) -> [3, 5, 8, 3]
Tree/to_list = @tree
  fold tree {
    Tree/Node: (List/concat (tree.left) (tree.right))  
    Tree/Leaf: (List/Cons tree.value [])
  }

#
#
# Tree/left:
#   returns the left child of the tree.
# Example:
#   (Node (Leaf 3) (Leaf 5)) -> (Leaf 3)
Tree/left (Tree/Node left _) = left
Tree/left (Tree/Leaf val) = (Tree/Leaf val)

#
#
# Tree/right:
#   returns the right child of the tree.
# Example:
#   (Node (Leaf 3) (Leaf 5)) -> (Leaf 5)
Tree/right (Tree/Node _ right) = right
Tree/right (Tree/Leaf val) = (Tree/Leaf val)

#
#
# Tree/value:
#   returns the value of the tree.
# Example:
#   (Leaf 3) -> 3
Tree/value (Tree/Node l r) = *
Tree/value (Tree/Leaf val) = val 
  
#
#
# Tree/zip_with:
#   returns a tree with the values of the two input trees combined using the function fn.
# Example:
#   (Node (Leaf 3) (Leaf 5)) (Node (Leaf 8) (Leaf 3)) (+) -> (Node (Leaf 11) (Leaf 8))
Tree/zip_with fn (Tree/Node l1 r1) (Tree/Node l2 r2) = (Tree/Node (Tree/zip_with fn l1 l2) (Tree/zip_with fn r1 r2))
Tree/zip_with fn (Tree/Leaf v1) (Tree/Leaf v2) = (Tree/Leaf (fn v1 v2))
Tree/zip_with fn (Tree/Leaf v1) (Tree/Node l2 r2) = *
Tree/zip_with fn (Tree/Node l1 r1) (Tree/Leaf v2) = *

#
#
# Tree/from_list:
#   returns a tree from a list of values.
# Example:
#   [3, 5, 8, 3] -> (Node (Node (Leaf 3) (Leaf 5)) (Node (Leaf 8) (Leaf 3))
Tree/from_list/aux/new_layer [] [] res = res
Tree/from_list/aux/new_layer [] (List/Cons t xt) res = *
Tree/from_list/aux/new_layer (List/Cons l xl) [] res = (Tree/from_list/aux/new_layer xl [l] res)
Tree/from_list/aux/new_layer (List/Cons l xl) (List/Cons t xt) res = (Tree/from_list/aux/new_layer xl [] (List/Cons (Tree/Node l t) res))

Tree/from_list/aux l 0 = (Tree/from_list/aux/new_layer (List/reverse l) [] [])
Tree/from_list/aux l iters = (Tree/from_list/aux (Tree/from_list/aux/new_layer (List/reverse l) [] []) (- iters 1))

Tree/from_list l = (Tree/from_list_val l 0)

# Tree/from_list_val:
#   returns a tree from a list of values, with the remaining values to have full tree filled with some value.
# Example:
#   [3, 5, 8, 3] 0 -> (Node (Node (Leaf 3) (Leaf 5)) (Node (Leaf 8) (Leaf 3))
#   [3, 5, 8] 1 -> (Node (Node (Leaf 3) (Leaf 5)) (Node (Leaf 8) (Leaf 1))
Tree/from_list_val = @l @val
  use len_l = (List/len l)
  use mapped = (List/map l (@x (Tree/Leaf x)))
  use extenstion = (List/create (Number/needed_for_power_of_two len_l) (Tree/Leaf val))
  (List/head (Tree/from_list/aux (List/concat mapped extenstion) (- (Number/log2/int len_l) 1)))

#
#
# Tree/sum:
#   returns the sum of the values in the tree.
# Example:
#   (Node (Node (Leaf 3) (Leaf 5)) (Node (Leaf 8) (Leaf 3))) -> 19
Tree/sum = @tree
  fold tree {
    Tree/Node: (+ (tree.left) (tree.right))
    Tree/Leaf: tree.value
  }

#
#
# Tree/len:
#   returns the number of nodes in the tree.
# Example:
#   (Node (Node (Leaf 3) (Leaf 5)) (Node (Leaf 8) (Leaf 3))) -> 4
Tree/len = @tree
  fold tree {
    Tree/Node: (+ (Tree/len tree.left) (Tree/len tree.right))
    Tree/Leaf: 1
  }


############################################
# Example usage of the functions above:
# main =
#   (Tree/generate 3)
#   (Tree/to_list (Tree/generate 3))
#   (Tree/left (Tree/generate 3))
#   (Tree/right (Tree/generate 3))
#   (Tree/value (Tree/generate 3))
#   (Tree/zip_with (+) (Tree/generate 3) (Tree/generate 3))
#   (Tree/from_list [3, 5, 8, 3])
#   (Tree/from_list_val [3, 5, 8, 3] 0)
#   (Tree/sum (Tree/generate 3))
#   (Tree/len (Tree/generate 3))

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
# Convolution of arrays size: 64 - 0.01s
# Convolution of arrays size: 128 - 0.05s
# Convolution of arrays size: 256 - 0.18s
# Convolution of arrays size: 512 - 0.71s
# Convolution of arrays size: 1024 - 2.97s

main = @layers
  use data = (data_gen (<< 2 layers))

  # Using List/len to not output the whole list, but still evaluating the whole list
  (List/len (List/convolve data data)) 
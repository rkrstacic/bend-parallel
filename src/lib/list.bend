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
List/concat = @l1 @l2
  match l1 {
    List/Cons: (List/Cons l1.head (List/concat l1.tail l2))
    List/Nil: l2
  }

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
List/reverse/aux = @acc @l
  match l {
    List/Nil: acc
    List/Cons: (List/reverse/aux (List/Cons l.head acc) l.tail)
  }
List/reverse = @l
  (List/reverse/aux [] l)

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
    List/Nil: [acc]
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
    List/Cons: (List/Cons (fn arr1/head (List/head arr2)) (arr1/tail (List/tail arr2)))
    List/Nil: List/Nil
  }

#################################

# Example usage of the functions above:
def main:
  return [1, 2, 3]
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

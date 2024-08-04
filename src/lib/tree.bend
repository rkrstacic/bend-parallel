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

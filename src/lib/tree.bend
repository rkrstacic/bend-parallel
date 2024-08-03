Tree/generate = @depth
  bend x = 0 {
    when (< x depth):
      (Tree/Node (fork (+ x 1)) (fork (+ x 1)))
    else:
      (Tree/Leaf x)
  }

Tree/to_list = @tree
  fold tree {
    Tree/Node: (List/concat (tree.left) (tree.right))  
    Tree/Leaf: (List/Cons tree.value [])
  }

Tree/left (Tree/Node left _) = left
Tree/left (Tree/Leaf val) = (Tree/Leaf val)

Tree/right (Tree/Node _ right) = right
Tree/right (Tree/Leaf val) = (Tree/Leaf val)

Tree/value (Tree/Node l r) = *
Tree/value (Tree/Leaf val) = val 
  
Tree/zip_with fn (Tree/Node l1 r1) (Tree/Node l2 r2) = (Tree/Node (Tree/zip_with fn l1 l2) (Tree/zip_with fn r1 r2))
Tree/zip_with fn (Tree/Leaf v1) (Tree/Leaf v2) = (Tree/Leaf (fn v1 v2))
Tree/zip_with fn (Tree/Leaf v1) (Tree/Node l2 r2) = *
Tree/zip_with fn (Tree/Node l1 r1) (Tree/Leaf v2) = *

Tree/from_list/aux/new_layer [] [] res = res
Tree/from_list/aux/new_layer [] (List/Cons t xt) res = *
Tree/from_list/aux/new_layer (List/Cons l xl) [] res = (Tree/from_list/aux/new_layer xl [l] res)
Tree/from_list/aux/new_layer (List/Cons l xl) (List/Cons t xt) res = (Tree/from_list/aux/new_layer xl [] (List/Cons (Tree/Node l t) res))

Tree/from_list/aux l 0 = (Tree/from_list/aux/new_layer (List/reverse l))
Tree/from_list/aux l iters = (Tree/from_list/aux (Tree/from_list/aux/new_layer (List/reverse l)) (- iters 1))

Tree/from_list l = (Tree/from_list_val l 0)

Tree/from_list_val = @l @val
  use len_l = (List/len l)
  use mapped = (List/map l (@x (Tree/Leaf x)))
  use extenstion = (List/create (Number/needed_for_power_of_two len_l) (Tree/Leaf val))
  (List/head (Tree/from_list/aux (List/concat mapped extenstion) (- (Number/log2/int len_l) 1)))


Tree/sum = @tree
  fold tree {
    Tree/Node: (+ (tree.left) (tree.right))
    Tree/Leaf: tree.value
  }

Tree/len = @tree
  fold tree {
    Tree/Node: (+ (Tree/len tree.left) (Tree/len tree.right))
    Tree/Leaf: 1
  }
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

Tree/from_list/aux/new_layer = @l
  use tmp = []
  use res = []
  fold l with tmp, res {
    List/Cons: match tmp {
      # previous el waiting for merge
      List/Cons: (l.tail [] (List/Cons (Tree/Node l.head tmp.head) res))
      List/Nil: (l.tail [l.head] res)
    }
    List/Nil: res
  }

Tree/from_list/aux = @l @iters
  use btree = (Tree/from_list/aux/new_layer (List/reverse l))
  switch iters {
    0: btree
    _: (Tree/from_list/aux btree (- iters 1))
  }

Tree/from_list = @l
  (Tree/from_list_val l 0)

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
type Tree:
  Node { ~left, ~right }
  Leaf { value }

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

Tree/sum = @tree
  fold tree {
    Tree/Node: (+ (tree.left) (tree.right))
    Tree/Leaf: tree.value
  }
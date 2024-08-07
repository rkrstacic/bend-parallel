type Tree:
  Node { ~left, ~right }
  Leaf { value }

List/concat = @l1 @l2
  match l1 {
    List/Cons: (List/Cons l1.head (List/concat l1.tail l2))
    List/Nil: l2
  }

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

List/is_single = @list
  (List/is_pair/aux list 1)

List/head = @l
  match l {
    List/Cons: l.head
    List/Nil: []
  }

List/tail = @l
  match l {
    List/Cons: l.tail
    List/Nil: l
  }

List/map = @list @fn
  fold list {
    List/Cons: (List/Cons (fn list.head) list.tail)
    List/Nil: List/Nil   
  }


List/len = @l
  match l {
    List/Nil: 0
    List/Cons: (+ 1 (List/len l.tail))
  }

List/create = @n @val
  bend x = 0 {
    when (< x n):
      (List/Cons val (List/create (- n 1) val))
    else:
      List/Nil
  }

List/dot/with.Tree = @l1 @l2
  use t1 = (Tree/from_list l1)
  use t2 = (Tree/from_list l2)
  (Tree/to_list (Tree/sum (Tree/zip_with Number/mul t1 t2)))


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

main =
  use l1 = [1, 2, 3, 4, 5]
  use l2 = [1, 2, 3, 4, 5]
  (List/dot/with.Tree l1 l2)

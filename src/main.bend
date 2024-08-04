List/create n val = if (> n 0) { (List/Cons val (List/create (- n 1) val)) } else { List/Nil }

List/dot arr1 arr2 = (List/sum (List/zip_with (@x @y (* x y)) arr1 arr2))

List/head (List/Cons x xs) = x
List/head [] = []

List/len/aux [] count = count
List/len/aux (List/Cons x xs) count = (List/len/aux xs (+ count 1))

List/len list = (List/len/aux list 0)

List/map [] fn = List/Nil
List/map (List/Cons x xs) fn = (List/Cons (fn x) (List/map xs fn))

List/reversed_tails/aux [] acc = []
List/reversed_tails/aux (List/Cons x xs) acc = (List/Cons acc (List/reversed_tails/aux xs (List/Cons x acc)))

List/reversed_tails [] = []
List/reversed_tails (List/Cons x xs) = (List/reversed_tails/aux xs [x])

List/sum [] = 0
List/sum (List/Cons x xs) = (+ x (List/sum xs))

List/tails [] = []
List/tails (List/Cons x xs) = (List/Cons (List/Cons x xs) (List/tails xs))

List/triangle arr = (List/concat (List/map (List/reversed_tails arr) List/reverse) (List/tails arr))

List/zip_with fn [] [] = List/Nil
List/zip_with fn [] (List/Cons x xs) = *
List/zip_with fn (List/Cons x xs) [] = *
List/zip_with fn (List/Cons x xs) (List/Cons y ys) = (List/Cons (fn x y) (List/zip_with fn xs ys))

Number/next_power_of_two/aux n x = if (> (+ x 1) n) { x } else { (Number/next_power_of_two/aux n (* x 2)) }

Number/next_power_of_two n = (Number/next_power_of_two/aux n 1)

Number/needed_for_power_of_two n = (- (Number/next_power_of_two n) n)

Number/log2/int/aux 0 acc = acc
Number/log2/int/aux n acc = (Number/log2/int/aux (/ n 2) (+ acc 1))

Number/log2/int n = (Number/log2/int/aux (- n 1) 0)

Tree/to_list (Tree/Node l r) = (List/concat (Tree/to_list l) (Tree/to_list r))
Tree/to_list (Tree/Leaf val) = (List/Cons val [])

Tree/left (Tree/Node left _) = left
Tree/left (Tree/Leaf val) = (Tree/Leaf val)

Tree/right (Tree/Node _ right) = right
Tree/right (Tree/Leaf val) = (Tree/Leaf val)

Tree/value (Tree/Node l r) = *
Tree/value (Tree/Leaf val) = val 

Tree/from_list/aux/new_layer [] [] res = res
Tree/from_list/aux/new_layer [] (List/Cons t xt) res = *
Tree/from_list/aux/new_layer (List/Cons l xl) [] res = (Tree/from_list/aux/new_layer xl [l] res)
Tree/from_list/aux/new_layer (List/Cons l xl) (List/Cons t xt) res = (Tree/from_list/aux/new_layer xl [] (List/Cons (Tree/Node l t) res))

Tree/from_list/aux l 0 = (Tree/from_list/aux/new_layer (List/reverse l) [] [])
Tree/from_list/aux l iters = (Tree/from_list/aux (Tree/from_list/aux/new_layer (List/reverse l) [] []) (- iters 1))

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

Tree/zip_with fn (Tree/Node l1 r1) (Tree/Node l2 r2) = (Tree/Node (Tree/zip_with fn l1 l2) (Tree/zip_with fn r1 r2))
Tree/zip_with fn (Tree/Leaf v1) (Tree/Leaf v2) = (Tree/Leaf (fn v1 v2))
Tree/zip_with fn (Tree/Leaf v1) (Tree/Node l2 r2) = *
Tree/zip_with fn (Tree/Node l1 r1) (Tree/Leaf v2) = *

List/convolve/with.Tree = @l1 @l2
  use t1 = (Tree/from_list_val (List/triangle l1) [0])
  use t2 = (Tree/from_list_val (List/reverse (List/triangle (List/reverse l2))) [0])
  (Tree/to_list (Tree/zip_with List/dot t1 t2))

main =
  use arr1 = [1, 2, 3, 4]
  use arr2 = [1, 2, 3, 4]

  (List/convolve/with.Tree arr1 arr2) 
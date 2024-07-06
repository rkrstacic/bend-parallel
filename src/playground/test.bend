type Tree:
  Node { ~left, ~right }
  Leaf { value }

List.concat = @l1 @l2
  match l1 {
    List/Cons: (List/Cons l1.head (List.concat l1.tail l2))
    List/Nil: l2
  }


Tree.generate = @depth
  bend x = 0 {
    when (< x depth):
      (Tree/Node (fork (+ x 1)) (fork (+ x 1)))
    else:
      (Tree/Leaf x)
  }

Tree.to_list = @tree
  match tree {
    Tree/Node: (List.concat (Tree.to_list tree.left) (Tree.to_list tree.right))  
    Tree/Leaf: (List/Cons tree.value [])
  }

Tree.left = @tree
  match tree {
    Tree/Node: tree.left
    Tree/Leaf: tree
  }

Tree.right = @tree
  match tree {
    Tree/Node: tree.right
    Tree/Leaf: tree
  }

Tree.value = @tree
  match tree {
    Tree/Node: 0
    Tree/Leaf: tree.value
  }

Tree.zip_with = @fn @tree1 @tree2
  fold tree1 with tree2 {
    Tree/Node: (Tree/Node (tree1.left (Tree.left tree2)) (tree1.right (Tree.right tree2)))
    Tree/Leaf: (Tree/Leaf (fn tree1.value (Tree.value tree2)))
  }

# [1, 2, 3, 4]
# [1, 2, 3, 4]
# [[1, 2], [3, 4]]


def main():
  tree1 = Tree.generate(3)
  tree2 = Tree.generate(3)
  return Tree.to_list(Tree.zip_with((lambda x, y: x + y), tree1, tree2))

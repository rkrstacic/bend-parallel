def range(n):
  first = 0
  last = n
  step = 1
  
  bend x = first:
    when x < last:
      next = fork(x + step)
      y = List/Cons { head: 1, tail: next }
    else:
      y = List/Nil

  return y

def sum_range(arr):
  fold arr:
    case List/Nil:
      return 0
    case List/Cons:
      return arr.head + arr.tail



type Tree:
  Node { ~lft, ~rgt }
  Leaf { val }

def new_tree(n):
  bend x = 0:
    when x < n:
      tree = Tree/Node { lft: fork(x + 1), rgt: fork(x + 1) }
    else:
      tree = Tree/Leaf { val: 1 }
  return tree


def sum_tree(tree):
  fold tree:
    case Tree/Leaf:
      return tree.val
    case Tree/Node:
      return sum_tree(tree.lft) + sum_tree(tree.rgt)

def pow(x, n):
  bend y = 1:
    when n > 0:
      y = x * pow(x, n - 1)
    else:
      y = 1
  return y


  

def arr_test(n):
  arr = range(pow(2, n))
  sum = sum_range(arr)

  return 123
  

def tree_test(n):
  tree = new_tree(n)
  sum = sum_tree(tree)

  return 123

def main():
  return arr_test(20)

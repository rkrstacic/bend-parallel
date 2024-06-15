
List.is_pair.aux = @list @iter
  match list {
    List/Cons: switch iter {
      0: 0
      _: (List.is_pair.aux list.tail (- iter 1))
    }
    List/Nil: switch iter {
      0: 1
      _: 0
    }
  }

List.is_pair = @list
  (List.is_pair.aux list 2)


def List.is_pair.test():
  return (
    List.is_pair([1, 2]) == 1 &
    List.is_pair([1, 2, 3]) == 0 &
    List.is_pair([1, 2, 3, 4]) == 0 &
    List.is_pair([1]) == 0
  )


def main:
  if List.is_pair.test():
    return "True"
  else:
    return "False"
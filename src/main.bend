##
# List Helper functions
#
List.head = @l
  match l {
    List/Cons: l.head
    List/Nil: l
  }

List.tail = @l
  match l {
    List/Cons: l.tail
    List/Nil: l
  }

List.concat = @l1 @l2
  match l1 {
    List/Cons: (List/Cons l1.head (List.concat l1.tail l2))
    List/Nil: l2
  }

List.len = @l
  match l {
    List/Nil: 0
    List/Cons: (+ 1 (List.len l.tail))
  }

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
  
List.to_btree.aux = @l
  match l {
    List/Cons: (List/Cons [l.head, (List.head l.tail)] (List.to_btree.aux (List.tail l.tail)))
    List/Nil: l
  }

List.to_btree = @l
  use btree = (List.to_btree.aux l)
  switch (List.is_pair btree) {
    0: (List.to_btree btree)
    _: btree
  }

##
# Map Helper functions
#
Map.fill.aux = @map @keys @val
  use map = (Map/set map keys val)
  switch keys {
    0: map
    _: (Map.fill.aux map (- keys 1) val)
  }

Map.fill = @keys
  (Map.fill.aux Map/empty keys 0)

def Map.increment(map, key, val):
  # Map.increment = @map @key @val
  #   (Map/set map key (+ (map[key]) val))
  curr = map[key]
  
  return Map/set(map, key, curr + val)


## 
# Main
#

get_inc = @el @ranges
  use i = 0
  fold ranges with i {
    List/Cons: if (> el ranges.head) { (ranges.tail (+ i 1)) } else { i }
    List/Nil: i
  }


# def histogram(list, ranges):
#   ans = Map.fill(List.len(ranges))
  
#   fold list with ans:
#     case List/Cons:
#       return list.tail(Map.increment(ans, get_inc(list.head, ranges), 1))
      
#     case List/Nil:
#       return ans
      
      
histogram = @list @ranges
  use ans = (Map.fill (List.len ranges))
  
  fold list with ans {
    List/Cons: (list.tail (Map.increment ans (get_inc list.head ranges) 1))  
    List/Nil: ans   
  }

def map_to_list.aux(map, i, acc):
  switch i:
    case 0:
      return List/Cons(map[acc], List/Nil)
    case _:
      return List/Cons(map[acc], map_to_list.aux(map, i - 1, acc + 1))

def map_to_list(map, i):
  return map_to_list.aux(map, i, 0)


def main():
  data = [3, 6, 2, 4, 6, 9, 6, 1, 2]
  ranges = [3, 6]
  
  hist = histogram(data, ranges)

  return map_to_list(hist, List.len(ranges))

  # Result: [4, 4, 1]
  # Explanation:
  # For the range < 3, we have 3, 2, 1, 2. So, 4 elements.
  # For the range 3-6, we have 6, 4, 6, 6. So, 4 elements.
  # For the range > 6, we have 9. So, 1 element.
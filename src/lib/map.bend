###########################################
### Map

# The Map type is builtin, so we don't need to declare it.
# But this is how it's defined in the builtins file.
# type Map:
#   Node { value ~left ~right }
#   Leaf

# Built-in functions:
# Map/empty: -> Map
# Map/set: Map -> uint -> uint -> Map
# Map/get: Map -> uint -> uint

###########################################
#
#
# Map increment:
#   Increments the value of a key in the map.
# Example:
#   {0: 1, 1: 2}, 1, 1 -> {0: 1, 1: 3}
def Map/increment(map, key, val):
  curr = map[key]
  
  return Map/set(map, key, curr + val)

#
#
# Map fill:
#   Creates a map with keys from 0 to n - 1, with value of 0.
# Example:
#   3 -> {0: 0, 1: 0, 2: 0}
Map/fill/aux = @map @keys @val
  use map = (Map/set map keys val)
  switch keys {
    0: map
    _: (Map/fill/aux map (- keys 1) val)
  }

Map/fill = @keys
  (Map/fill/aux Map/empty keys 0)

#################################

# Example usage of the functions above:
def main:
  return {0: 0, 1: 0, 2: 0}
  # return Map/fill(3)
  # return Map/increment({0: 1, 1: 2}, 1, 1)
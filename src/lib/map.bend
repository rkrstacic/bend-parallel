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


def main:
  # return Map.fill(10)
  # return Map.increment(Map.fill(10), 5, 1)
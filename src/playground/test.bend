def Map.set(map, key, val):
  map[key] = val
  return map

Map.fill.aux = @map @keys @val
  use map = (Map.set map keys val)
  switch keys {
    0: map
    _: (Map.fill.aux map (- keys 1) val)
  }

Map.fill = @keys
  (Map.fill.aux Map/empty keys 0)

Map.increment = @map @key @val
  use curr = map[key]
  map[key] = (+ curr val)
  map

def main():
  map = Map.fill(3)
  return map[2]
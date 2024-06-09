def main():
  # return example_1("argument")
  # return example_2(1, 2, 3)
  # return example_3(5)
  return example_4((10.0, 10.0), (20.0, 20.0))


def example_1(arg):
  return arg

def example_2(a, b, c):
  return a + b + c

def example_3(n):
  if n % 2 == 0:
    return "even"
  else:
    return "odd"

def example_4(a, b):
  (ax, ay) = a
  (bx, by) = b
  return ( (bx - ax) ** 2.0 + (by - ay) ** 2.0 ) ** 0.5

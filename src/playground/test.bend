# Circle
# - get radius
# - get area
# Square
# - get circumference
# - get area

type Shape:
  Circle { radius }
  Rectangle { width, height }

def area(shape):
  match shape:
    case Shape/Circle:
      return 3.14 * shape.radius ** 2.0
    case Shape/Rectangle:
      return shape.width * shape.height

def circumference(shape):
  match shape:
    case Shape/Circle:
      return shape.radius * 2.0 * 3.14
    case Shape/Rectangle:
      return shape.width * 2.0 + shape.height * 2.0

def fib_par(n):
  switch n:
    case 0:
      return 0
    case 1:
      return 1
    case _:
      return fib_par(n - 1) + fib_par(n - 2)

def fib_seq(n):
  bend a=0, b=1, n:
    when n != 0:
      return fork(b, a + b, n - 1)
    else:
      return a

def test_fib(fn):
  return (
    fn(1) == 1 &
    fn(2) == 1 &
    fn(3) == 2 &
    fn(4) == 3 &
    fn(5) == 5
  )

def test_fibs():
  if test_fib(fib_par) & test_fib(fib_seq):
    return "Passes"
  else:
    return "Fails"


def main(x):
  return fib_seq(x)

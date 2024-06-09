def gen(n, i):
  switch n:
    case 0:
      return i
    case _:
      return (gen(n - 1, i * 2), gen(n - 1, i * 2 + 1))

def gen2(n, i):
  switch n:
    case 0:
      return i
    case _:
      return (i, gen2(n - 1, i + 1))

def pow(x, n):
  bend y = 1:
    when n > 0:
      y = x * pow(x, n - 1)
    else:
      y = 1
  return y


def sum(arr):
  fold arr:
    case List/Nil:
      return 0
    case List/Cons:
      return arr.head + arr.tail

def main():
  return gen(4, 0)
  return sum(gen2(pow(2, 4), 0))
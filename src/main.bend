# ITRS: 436207599
# Seq 8.31s (52.5 mips)
# Par 0.83s (525 mips)
# x10 improvement
main =
  bend x = 0 {
    when (< x 24):
      (+ (fork (+ x 1)) (fork (+ x 1)))
    else:
      x
  }
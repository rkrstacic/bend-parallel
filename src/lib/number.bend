################################
### Number helper functions: ###
#
#
# List of functions in this file:
# - Number/next_power_of_two
# - Number/needed_for_power_of_two
# - Number/mul
# - Number/log2/int


###########################################
#
#
# Number/next_power_of_two:
#   returns the next power of two greater than n.
# Example:
#   5 -> 8
#   8 -> 8
#   9 -> 16
Number/next_power_of_two/aux n x = if (> (+ x 1) n) { x } else { (Number/next_power_of_two/aux n (* x 2)) }

Number/next_power_of_two n = (Number/next_power_of_two/aux n 1)

#
#
# Number/needed_for_power_of_two:
#   returns the number needed to reach the next power of two.
# Example:
#   5 -> 3
#   8 -> 0
#   9 -> 7
Number/needed_for_power_of_two n = (- (Number/next_power_of_two n) n)

#
#
# Number/mul:
#   returns the product of x and y.
# Example:
#   5 3 -> 15
#   8 8 -> 64
Number/mul x y = (* x y)

#
#
# Number/log2/int:
#   returns the integer part of the base 2 logarithm of n.
# Example:
#   5 -> 2
#   8 -> 3
#   9 -> 3
Number/log2/int/aux 0 acc = acc
Number/log2/int/aux n acc = (Number/log2/int/aux (/ n 2) (+ acc 1))

Number/log2/int n = (Number/log2/int/aux (- n 1) 0)


############################################
# Example usage of the functions above:
# main =
#   (Number/next_power_of_two 5)
#   (Number/needed_for_power_of_two 5)
#   (Number/mul 5 3)
#   (Number/log2/int 5)

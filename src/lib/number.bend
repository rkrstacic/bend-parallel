Number/next_power_of_two/aux n x = if (> (+ x 1) n) { x } else { (Number/next_power_of_two/aux n (* x 2)) }

Number/next_power_of_two n = (Number/next_power_of_two/aux n 1)


Number/needed_for_power_of_two n = (- (Number/next_power_of_two n) n)


Number/mul x y = (* x y)


Number/log2/int/aux 0 acc = acc
Number/log2/int/aux n acc = (Number/log2/int/aux (/ n 2) (+ acc 1))

Number/log2/int n = (Number/log2/int/aux (- n 1) 0)

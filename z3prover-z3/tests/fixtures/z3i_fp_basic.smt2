(declare-const x (_ FloatingPoint 8 24))
(assert (= x (fp #b1 #x7f #b10000000000000000000000)))
(check-sat)
(get-model)

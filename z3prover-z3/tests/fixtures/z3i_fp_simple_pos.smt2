(declare-const x Float32)
(assert (= x (fp #b0 #x7f #b00000000000000000000000)))
(check-sat)
(get-model)

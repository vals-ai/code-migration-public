(declare-const fp Float32)
(assert (= fp (fp #b0 #b10000001 #b01000000000000000000000)))
(check-sat)
(get-model)

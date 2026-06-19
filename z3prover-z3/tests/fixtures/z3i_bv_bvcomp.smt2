(set-logic QF_BV)
(assert (= (bvcomp #x0f #x0f) #b1))
(check-sat)

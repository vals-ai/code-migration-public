(set-logic QF_BV)
(assert (= (bvnor #x0f #xf0) #x00))
(check-sat)

(set-logic QF_BV)
(assert (= (bvxnor #x0f #x0f) #xff))
(check-sat)

(set-logic QF_BV)
(assert (= (bvnand #x0f #xff) #xf0))
(check-sat)

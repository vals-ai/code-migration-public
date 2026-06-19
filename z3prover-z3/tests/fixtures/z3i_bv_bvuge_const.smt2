(set-logic QF_BV)
(assert (bvuge #xff #x01))
(check-sat)

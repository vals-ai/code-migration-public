(set-logic QF_BV)
(assert (= (bvashr #xff #x03) #xff))
(check-sat)

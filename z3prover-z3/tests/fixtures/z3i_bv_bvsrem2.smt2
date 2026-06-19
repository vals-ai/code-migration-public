(set-logic QF_BV)
(assert (= (bvsrem #xfd #x03) #x00))
(check-sat)

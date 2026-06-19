(set-logic QF_BV)
(assert (= (bvsrem #xfd #x02) #xff))
(check-sat)

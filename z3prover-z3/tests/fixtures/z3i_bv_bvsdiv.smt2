(set-logic QF_BV)
(assert (= (bvsdiv #xfd #x02) #xff))
(check-sat)

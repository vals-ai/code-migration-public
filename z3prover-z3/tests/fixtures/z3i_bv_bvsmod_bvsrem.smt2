(set-logic QF_BV)
(assert (= (bvsmod #xfd #x02) #x01))
(check-sat)

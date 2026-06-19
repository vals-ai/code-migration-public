(set-logic QF_BV)
(assert (= ((_ rotate_right 2) #b00001111) #b11000011))
(check-sat)

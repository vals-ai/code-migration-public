(declare-const x (_ BitVec 8))
(assert (= ((_ rotate_left 3) x) #xb8))
(check-sat)
(get-model)

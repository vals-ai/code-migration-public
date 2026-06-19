(declare-const x (_ BitVec 4))
(assert (= ((_ sign_extend 4) x) #xf8))
(check-sat)
(get-model)

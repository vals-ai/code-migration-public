(declare-const x (_ BitVec 5))
(assert (= x #b11111))
(check-sat)
(get-model)

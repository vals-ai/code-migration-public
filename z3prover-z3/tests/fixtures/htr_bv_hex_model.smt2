(declare-const x (_ BitVec 12))
(assert (= x #b001101000110))
(check-sat)
(get-model)

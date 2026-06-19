(declare-const x (_ BitVec 4))
(assert (= ((_ zero_extend 4) x) (_ bv170 8)))
(check-sat)
(get-model)

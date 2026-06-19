(declare-const x Float32)
(assert (= x (_ +oo 8 24)))
(check-sat)
(get-model)

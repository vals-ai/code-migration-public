(declare-const x (_ FloatingPoint 8 24))
(assert (= x (fp.mul RNE ((_ to_fp 8 24) RNE 2.5) ((_ to_fp 8 24) RNE 3.0))))
(check-sat)
(get-model)

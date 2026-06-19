(declare-const x (_ FloatingPoint 8 24))
(assert (fp.isNaN x))
(check-sat)
(get-model)

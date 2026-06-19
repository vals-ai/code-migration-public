(declare-const x Float32)
(assert (fp.isNaN x))
(check-sat)
(get-model)

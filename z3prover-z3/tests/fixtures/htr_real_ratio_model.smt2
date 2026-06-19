(declare-const x Real)
(assert (= x 3.14))
(check-sat)
(get-model)

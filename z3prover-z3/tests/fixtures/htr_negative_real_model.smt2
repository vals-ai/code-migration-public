(declare-const x Real)
(assert (= x (- 1.5)))
(check-sat)
(get-model)

; Model gen: get-value on Real constants, fractions, arithmetic exprs
(set-logic QF_LRA)
(set-option :produce-models true)
(declare-const x Real)
(declare-const y Real)
(assert (= x (/ 1.0 3.0)))
(assert (= y (* x 3.0)))
(check-sat)
(get-value (x y (/ x 2.0) (+ x y)))

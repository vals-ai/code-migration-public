; Tactic: quantifier elimination via check-sat on an exists formula
(set-logic LIA)
(set-option :produce-models true)
(declare-const x Int)
; check: is there a y such that y>0 and x+y=10? (answer: x < 10)
(assert (> x 8))
(assert (exists ((y Int)) (and (> y 0) (= (+ x y) 10))))
(check-sat)
(get-value (x))

; Quantifier: exists with a witness - sat
(set-logic LIA)
(set-option :produce-models true)
(declare-const k Int)
(assert (> k 0))
(assert (exists ((x Int) (y Int)) (and (> x 0) (> y 0) (= (+ (* x x) (* y y)) (* k k)))))
(assert (= k 5))
(check-sat)
(get-value (k))

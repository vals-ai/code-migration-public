; Parser edge case: deeply nested let bindings
(set-logic QF_LIA)
(set-option :produce-models true)
(declare-const a Int)
(assert
  (let ((x (+ a 1)))
  (let ((y (* x 2)))
  (let ((z (- y 3)))
  (let ((w (+ z z)))
    (= w 10))))))
(check-sat)
(get-value (a))

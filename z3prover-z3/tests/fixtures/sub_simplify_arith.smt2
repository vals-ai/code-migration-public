; Tactic/Simplifier: simplify arithmetic expressions
(set-logic QF_LIA)
(declare-const x Int)
(simplify (+ x 0))
(simplify (* x 1))
(simplify (+ (* 2 x) (* 3 x)))
(simplify (- (+ x 5) 5))
(simplify (and true (> x 0)))
(simplify (or false (= x x)))

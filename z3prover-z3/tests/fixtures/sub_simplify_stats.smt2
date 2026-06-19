; Tactic/Simplifier edge case: simplify with print_statistics
(set-logic QF_LIA)
(declare-const x Int)
(declare-const y Int)
(simplify (and (>= x 0) (<= x 10) (>= y 0) (<= y 10) (= (+ x y) 15)) :print_statistics true)

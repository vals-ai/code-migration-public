; Quantifier: forall with integer arithmetic - unsat (counterexample exists)
(set-logic LIA)
(assert (not (forall ((x Int)) (>= (* x x) 0))))
(check-sat)

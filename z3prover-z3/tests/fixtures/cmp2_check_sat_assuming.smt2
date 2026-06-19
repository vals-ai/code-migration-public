(declare-const x Int)
(assert (> x 0))
(check-sat-assuming ((> x 5)))

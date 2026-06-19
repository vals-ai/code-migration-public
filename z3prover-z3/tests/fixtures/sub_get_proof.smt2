; Model gen: get-proof for a simple propositional unsat
(set-logic QF_LIA)
(set-option :produce-proofs true)
(declare-const x Int)
(assert (> x 5))
(assert (< x 3))
(check-sat)
(get-proof)

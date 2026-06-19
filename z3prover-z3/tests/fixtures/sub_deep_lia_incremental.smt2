; Deep-dive: incremental solving with multiple check-sat calls without push/pop
(set-logic QF_LIA)
(set-option :produce-models true)
(declare-const x Int)
; First check: satisfiable
(assert (> x 0))
(check-sat)
(get-value (x))
; Add more constraints: x is now also constrained to be even
(assert (= (mod x 2) 0))
(check-sat)
(get-value (x))
; Make it unsat: add (< x 0)
(assert (< x 0))
(check-sat)

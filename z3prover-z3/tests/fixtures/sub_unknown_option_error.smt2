; Parser edge case: unknown command-line-like option inside SMT2 triggers (error ...)
(set-logic QF_LIA)
(set-option :nonexistent-option true)
(check-sat)

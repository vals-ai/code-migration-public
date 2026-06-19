(set-option :smtlib2-compliant true)
(declare-const x Int)
(assert (= x 5))
(check-sat)

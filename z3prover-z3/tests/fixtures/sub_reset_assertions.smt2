; Parser/Command-Context: reset-assertions retains declarations
(set-logic QF_LIA)
(set-option :produce-models true)
(declare-const x Int)
(assert (= x 99))
(check-sat)
(reset-assertions)
; x is still declared, but the assertion is gone
(assert (= x 42))
(check-sat)
(get-value (x))

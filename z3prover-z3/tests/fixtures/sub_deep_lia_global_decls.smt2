; Deep-dive: global-decls=false hides declarations after reset
(set-option :global-decls false)
(set-logic QF_LIA)
(set-option :produce-models true)
(push 1)
  (declare-const x Int)
  (assert (= x 7))
  (check-sat)
  (get-value (x))
(pop 1)
; With global-decls=false, x is no longer visible after pop
; Declaring x again works
(declare-const x Int)
(assert (= x 99))
(check-sat)
(get-value (x))

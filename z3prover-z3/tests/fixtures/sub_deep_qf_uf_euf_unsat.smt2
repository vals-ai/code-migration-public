; Deep-dive: EUF (equality with uninterpreted functions) unsat via theory reasoning
; Classic: f(f(f(a))) = a, f(f(a)) = a --> f(a) = a, then f(a) != a is unsat
(set-logic QF_UF)
(declare-sort T 0)
(declare-fun f (T) T)
(declare-const a T)
; f(f(f(a))) = a
(assert (= (f (f (f a))) a))
; f(f(a)) = a 
(assert (= (f (f a)) a))
; now f(a) must equal a because:
;   f(f(f(a))) = a and f(f(a)) = a implies f(a) = a
; So asserting f(a) != a is unsat
(assert (not (= (f a) a)))
(check-sat)

; Test fp.abs and fp.neg
(set-logic QF_FP)
(set-option :produce-models true)
(declare-const x Float32)
; fp.abs(-1.0) = 1.0
(assert (fp.eq (fp.abs (fp #b1 #x7f #b00000000000000000000000)) 
               (fp #b0 #x7f #b00000000000000000000000)))
; x = fp.neg(1.0) = -1.0
(assert (= x (fp.neg (fp #b0 #x7f #b00000000000000000000000))))
(check-sat)
(get-model)

; Test fp.min and fp.max operations
(set-logic QF_FP)
(set-option :produce-models true)
(declare-const r1 Float32)
(declare-const r2 Float32)
; fp.min of 1.0 and 2.0 should be 1.0
(assert (= r1 (fp.min (fp #b0 #x7f #b00000000000000000000000)  
                       (fp #b0 #x80 #b00000000000000000000000))))
; fp.max of 1.0 and 2.0 should be 2.0
(assert (= r2 (fp.max (fp #b0 #x7f #b00000000000000000000000)  
                       (fp #b0 #x80 #b00000000000000000000000))))
(check-sat)
(get-model)

; Deep-dive: floating-point rounding modes comparison
(set-logic QF_FP)
(set-option :produce-models true)
(declare-const a Float64)
(declare-const b Float64)
; a = 1.0, b = 3.0
(assert (= a (fp #b0 #b01111111111 #b0000000000000000000000000000000000000000000000000000)))
(assert (= b (fp #b0 #b10000000000 #b1000000000000000000000000000000000000000000000000000)))
; 1.0 / 3.0 rounded to nearest even vs toward zero
(declare-const rne Float64)
(declare-const rtz Float64)
(assert (= rne (fp.div roundNearestTiesToEven a b)))
(assert (= rtz (fp.div roundTowardZero a b)))
(check-sat)
(get-value (rne rtz))

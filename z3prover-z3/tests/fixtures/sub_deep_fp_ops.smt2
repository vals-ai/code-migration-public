; Deep-dive: floating-point special values (NaN, infinity, rounding modes)
(set-logic QF_FP)
(set-option :produce-models true)
; Float32 = 1 sign bit, 8 exponent bits, 23 significand bits
; +infinity = sign=0, exp=all-ones, sig=all-zeros
(declare-const x Float32)
(declare-const y Float32)
; x is positive infinity via bit-pattern
(assert (= x (fp #b0 #b11111111 #b00000000000000000000000)))
; y is a quiet NaN via bit-pattern
(assert (= y (fp #b0 #b11111111 #b10000000000000000000000)))
; NaN is not equal to anything including itself
(assert (not (fp.eq y y)))
; +inf is infinite
(assert (fp.isInfinite x))
(check-sat)
(get-value (x y (fp.isNaN y) (fp.isInfinite x) (fp.isPositive x)))

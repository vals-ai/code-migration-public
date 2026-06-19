; QF_BV: bit-vector arithmetic – signed overflow, shifts, concat, extract
(set-logic QF_BV)
(set-option :produce-models true)
(declare-const a (_ BitVec 8))
(declare-const b (_ BitVec 8))
(assert (= a #x7f))
(assert (= b #x01))
; signed add overflows: 127 + 1 = -128 in signed 8-bit
(assert (= (bvadd a b) #x80))
; extract high nibble
(assert (= ((_ extract 7 4) a) #x7))
; concat two nibbles
(assert (= (concat #x3 #xc) #x3c))
(check-sat)
(get-value (a b (bvadd a b) (bvshl a (_ bv1 8)) (bvlshr a (_ bv1 8))))

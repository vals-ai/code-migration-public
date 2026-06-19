; QF_BV: zero-extend, sign-extend, rotate ops
(set-logic QF_BV)
(set-option :produce-models true)
(declare-const a (_ BitVec 4))
(assert (= a #xf))
; zero-extend to 8 bits: #x0f
(assert (= ((_ zero_extend 4) a) #x0f))
; sign-extend #xf (= -1 in 4-bit signed) to 8 bits: #xff
(assert (= ((_ sign_extend 4) a) #xff))
(check-sat)
(get-value (a ((_ zero_extend 4) a) ((_ sign_extend 4) a)))

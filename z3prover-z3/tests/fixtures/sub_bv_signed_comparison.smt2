; QF_BV edge case: signed vs unsigned comparison on same bit pattern
; #xff is -1 signed, 255 unsigned
(set-logic QF_BV)
(set-option :produce-models true)
(declare-const x (_ BitVec 8))
(assert (= x #xff))
; bvslt: signed less-than: -1 < 0 is true
(assert (bvslt x (_ bv0 8)))
; bvult: unsigned less-than: 255 < 0 is false, so negate it
(assert (not (bvult x (_ bv0 8))))
(check-sat)
(get-value (x))

; Deep-dive: bit-vector division by zero semantics (SMT-LIB2 spec: returns all-ones)
(set-logic QF_BV)
(set-option :produce-models true)
(declare-const x (_ BitVec 8))
(assert (= x #x05))
; bvudiv x 0 = #xff (all ones) per spec
(assert (= (bvudiv x (_ bv0 8)) #xff))
; bvsdiv x 0 = #xff (all ones) per spec for positive numerator
(assert (= (bvsdiv x (_ bv0 8)) #xff))
; bvurem x 0 = x per spec
(assert (= (bvurem x (_ bv0 8)) x))
(check-sat)
(get-value (x (bvudiv x (_ bv0 8)) (bvurem x (_ bv0 8))))

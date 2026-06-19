; Deep-dive: bit-vector concat/extract round-trip and arithmetic on sub-parts
(set-logic QF_BV)
(set-option :produce-models true)
(declare-const hi (_ BitVec 4))
(declare-const lo (_ BitVec 4))
(declare-const combined (_ BitVec 8))
; combined = concat(hi, lo)
(assert (= combined (concat hi lo)))
(assert (= hi #xa))
(assert (= lo #xb))
; extract should round-trip
(assert (= ((_ extract 7 4) combined) hi))
(assert (= ((_ extract 3 0) combined) lo))
; combined as hex = #xab
(assert (= combined #xab))
(check-sat)
(get-value (hi lo combined))

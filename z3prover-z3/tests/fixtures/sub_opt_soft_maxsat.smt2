; Optimization: MaxSAT with soft constraints and weights
(set-logic QF_LIA)
(set-option :produce-models true)
(declare-const x Int)
; hard constraint
(assert (and (>= x 0) (<= x 5)))
; soft constraints with weights
(assert-soft (= x 1) :weight 10)
(assert-soft (= x 2) :weight 5)
(assert-soft (> x 3) :weight 8)
(check-sat)
(get-model)
(get-objectives)

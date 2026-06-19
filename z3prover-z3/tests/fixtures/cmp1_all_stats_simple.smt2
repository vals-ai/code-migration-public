(declare-const x Int)
(assert (= x 5))
(check-sat)
(get-info :all-statistics)

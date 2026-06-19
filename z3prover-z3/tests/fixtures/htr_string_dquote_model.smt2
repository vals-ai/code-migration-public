(declare-const s String)
(assert (= s "quote""test"))
(check-sat)
(get-model)

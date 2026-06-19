; QF_S: string with regex membership and indexof
(set-logic QF_S)
(set-option :produce-models true)
(declare-const s String)
(assert (str.in.re s (re.++ (str.to.re "foo") (re.* (str.to.re "b")))))
(assert (= (str.len s) 5))
(check-sat)
(get-value (s))

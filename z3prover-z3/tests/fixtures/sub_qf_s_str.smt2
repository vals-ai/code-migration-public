; QF_S: string theory - concatenation, length, contains
(set-logic QF_S)
(set-option :produce-models true)
(declare-const x String)
(declare-const y String)
(assert (= (str.++ x y) "hello world"))
(assert (= (str.len x) 5))
(check-sat)
(get-value (x y))

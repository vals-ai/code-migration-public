; define-fun as macro + get-value
(set-logic QF_NIA)
(set-option :produce-models true)
(define-fun square ((x Int)) Int (* x x))
(define-fun cube ((x Int)) Int (* x x x))
(declare-const a Int)
(assert (= (square a) 25))
(check-sat)
(get-value (a (square a) (cube a)))

; Recursive function (factorial) with define-fun-rec
(set-logic ALL)
(set-option :produce-models true)
(define-fun-rec fact ((n Int)) Int
  (ite (= n 0) 1 (* n (fact (- n 1)))))
(declare-const r Int)
(assert (= r (fact 5)))
(check-sat)
(get-value (r))

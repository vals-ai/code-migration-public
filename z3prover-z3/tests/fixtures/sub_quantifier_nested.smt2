; Quantifier: nested forall/exists (LIA)
; "for all x > 0, there exists y > x" - sat
(set-logic LIA)
(assert (forall ((x Int)) (=> (> x 0) (exists ((y Int)) (> y x)))))
(check-sat)

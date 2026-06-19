; test get-value with complex BV expression
(set-logic QF_BV)
(set-option :produce-models true)
(declare-const x (_ BitVec 8))
(assert (= x #x42))
(check-sat)
(get-value (x (bvnot x) (bvadd x #x01)))

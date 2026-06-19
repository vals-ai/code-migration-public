; Tactic/Simplifier: simplify bit-vector expressions
(set-logic QF_BV)
(declare-const x (_ BitVec 8))
(simplify (bvadd x (_ bv0 8)))
(simplify (bvand x (_ bv255 8)))
(simplify (bvor x (_ bv0 8)))
(simplify (bvnot (bvnot x)))
(simplify (bvmul x (_ bv1 8)))
(simplify (bvshl x (_ bv0 8)))

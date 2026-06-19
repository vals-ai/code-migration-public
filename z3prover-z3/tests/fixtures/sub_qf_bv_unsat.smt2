; QF_BV: unsat - no 8-bit value satisfies bvugt of itself
(set-logic QF_BV)
(declare-const x (_ BitVec 8))
(assert (bvugt x x))
(check-sat)

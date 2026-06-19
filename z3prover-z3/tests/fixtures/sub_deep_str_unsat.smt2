; Deep-dive: string theory unsat - impossible length + content constraint
(set-logic QF_S)
(declare-const s String)
; s contains "abc" but has length < 3: impossible
(assert (str.contains s "abc"))
(assert (< (str.len s) 3))
(check-sat)

(declare-const p Bool)
(declare-const q Bool)
(assert p)
(check-sat-assuming (p (not q)))

; Parser edge case: quoted symbols (|...|) and symbols with special chars
(set-logic QF_LIA)
(set-option :produce-models true)
(declare-const |my var with spaces| Int)
(declare-const |x+y| Int)
(assert (= |my var with spaces| 7))
(assert (= |x+y| (+ |my var with spaces| 1)))
(check-sat)
(get-value (|my var with spaces| |x+y|))

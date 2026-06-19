; Parser/Command-Context: get-assertions in interactive mode
(set-option :produce-assertions true)
(set-logic QF_LIA)
(declare-const x Int)
(declare-const y Int)
(assert (> x 0))
(assert (> y 0))
(assert (< (+ x y) 10))
(get-assertions)

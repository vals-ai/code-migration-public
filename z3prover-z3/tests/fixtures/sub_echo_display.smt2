; Parser/Command-Context: echo and display commands
(echo "hello world")
(echo "line with a double-quote inside: it uses two double quotes")
(set-logic QF_LIA)
(declare-const x Int)
(assert (= x 10))
(display x)
(display (+ x 5))

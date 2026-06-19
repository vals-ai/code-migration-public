; Test str.replace and str.indexof operations
(set-logic QF_S)
(set-option :produce-models true)
(declare-const s String)
(declare-const idx Int)
; test str.indexof 
(assert (= s "hello world"))
(assert (= idx (str.indexof s "world" 0)))
(check-sat)
(get-model)

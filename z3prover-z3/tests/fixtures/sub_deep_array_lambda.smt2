; Deep-dive: array theory with const array and extensionality
(set-logic ALL)
(set-option :produce-models true)
(declare-const arr1 (Array Int Int))
(declare-const arr2 (Array Int Int))
; arr1 is a constant array (all zeros)
(assert (= arr1 ((as const (Array Int Int)) 0)))
; arr2 is arr1 with index 5 set to 100
(assert (= arr2 (store arr1 5 100)))
(check-sat)
(get-value ((select arr1 0) (select arr1 5) (select arr2 0) (select arr2 5)))

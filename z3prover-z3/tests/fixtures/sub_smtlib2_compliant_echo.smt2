; Parser edge case: echo in smt2-compliant mode (wraps output in quotes)
(set-option :print-success false)
(set-logic QF_LIA)
(echo "test message")

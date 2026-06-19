Punct-then-asterisk: foo.*bar* should not emphasize from left.

Letter-then-asterisk: foo*bar* baseline.

Star at start: *foo* baseline.

Punctuation-only flanking: !*foo*! emphasize?

Apostrophe boundary: don't*emph*here.

Underscore intra: foo_bar_baz NO emphasis.

Underscore boundary: !_foo_!  emph?

Mixed Unicode: 中文*emph*中文 — Unicode boundary check.

End-of-line flank: line ends with*foo*

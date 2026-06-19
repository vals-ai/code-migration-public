[multi    word]: https://example.com/multi

[multi word] — single space match.

[multi   word] — internal triple space, should match (whitespace collapsed).

[multi
word] — newline-separated label, should match.

[ MULTI    WORD ] — leading/trailing spaces + uppercase.

[multi	word] — tab-separated, should match.

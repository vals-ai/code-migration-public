Plain http://example.com/path autolinks.

But http://localhost:8080/test should NOT autolink without --relaxed-autolinks.

Single-token http://nope (no TLD) should NOT autolink either.

Punycode http://xn--mnchen-3ya.de/ should autolink.

IRC scheme irc://irc.libera.chat/comrak should not be autolinked by GFM autolink.

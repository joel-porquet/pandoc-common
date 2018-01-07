#!/usr/bin/env python

"""
Pandoc filter to pass all code blocks through pygments highlighter.

By default, pandoc uses highlighting-kate to do the highlighting. Note that the
"--highlight-style" option offered by pandoc only affects the generated color
scheme, not the highlighting engine. That's why we need an extra filter in order
to actually use pygments.
"""

from pandocfilters import toJSONFilter, RawBlock
from pygments import highlight
from pygments.lexers import (get_lexer_by_name, guess_lexer, TextLexer)
from pygments.formatters import get_formatter_by_name

def pygmentize(key, value, format, meta):
  if key == 'CodeBlock':
    [[ident, classes, keyvals], code] = value
    lexer = None
    for klass in classes:
      try:
        lexer = get_lexer_by_name(klass)
        break
      except:
        pass
    if lexer is None:
      try:
        lexer = guess_lexer(code)
      except:
        lexer = TextLexer()
    return [RawBlock(format, highlight(code, lexer, get_formatter_by_name(format)))]

if __name__ == "__main__":
    toJSONFilter(pygmentize)

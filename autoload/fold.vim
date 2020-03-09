
" indent('.') / indent(line(.))
" synIDattr(synID(line('.'), 1, 1), 'name')
" foldlevel('.') / foldlevel(line('.'))
" help:
"   http://vimdoc.sourceforge.net/htmldoc/fold.html#folds
"   http://vimdoc.sourceforge.net/htmldoc/usr_41.html

" {{{ FOLDING

let s:pattern_header = '^#\{1,6}\s'

function! fold#FoldLevelOfLine(lnum)

   " stop if file has one line only
  if line('$') <= 1
    return -1
  endif

  let cur_line = getline(a:lnum)
  let nxt_line = getline(a:lnum + 1)
  let prv_line =  getline(a:lnum - 1)

  let prv_syntax_group = synIDattr(synID(a:lnum - 1, 1, 1), 'name')
  let cur_syntax_group = synIDattr(synID(a:lnum, 1, 1), 'name')  " s:SyntaxGroupOfLineIs(a:lnum, '^markdownListItem')
  let nxt_syntax_group = synIDattr(synID(a:lnum + 1, 1, 1), 'name')

  " an empty line is not going to change the indentation level
  if match(cur_line, '^\s*$') >= 0
    return '='
  endif

  " ------- folding atx headers ------
  if match(cur_line, s:pattern_header) >= 0
    let header_level = strlen(substitute(cur_line, '^\(#\{1,6}\).*', '\1', ''))
    return '>' . header_level
  endif


  " ---------- Folding Lists -----------
  if cur_syntax_group =~? 'mkdListItem'

    let cur_indent = indent(a:lnum)

    " initial list indent level / each new list starts after an empty line
    " or a header (consistent with pandoc)
    if match(prv_line, '^\s*$') >= 0 || match(prv_line, s:pattern_header)>=0
      let s:list_indent_ini = cur_indent
      let s:list_foldlevel_ini = foldlevel(a:lnum-1)
    endif

    let cur_foldlevel = s:list_foldlevel_ini + (cur_indent - s:list_indent_ini)/&shiftwidth

    return '>' . (cur_foldlevel + 1)

  endif

  " === Folding Code ===
  if cur_syntax_group =~ 'mkdCodeStart'
    return 'a1'
  endif

  if cur_syntax_group =~ 'mkdCodeEnd'
    return 's1'
  endif

  if cur_syntax_group =~ 'mkdSnippet'
    return '='
  endif

  " folding fenced code blocks
  if match(cur_line, '^\s*```') >= 0
    if nxt_syntax_group ==? 'markdownFencedCodeBlock' || nxt_syntax_group =~? 'mkdCode' || nxt_syntax_group =~? 'mkdSnippet'
      return 'a1'
    endif
    return 's1'
  endif

  " folding code blocks
  if match(cur_line, '^\s\{4,}') >= 0
    if cur_syntax_group ==? 'markdownCodeBlock'
      if prv_syntax_group !=? 'markdownCodeBlock'
        return 'a1'
      endif
      if nxt_syntax_group !=? 'markdownCodeBlock'
        return 's1'
      endif
    endif
    return '='
  endif

  " === Folding Math ===
  if cur_syntax_group =~? 'texMathZone' && prv_syntax_group !~? 'texMathZone' && nxt_syntax_group =~? 'texMathZone'
    return 'a1'
  endif

  if cur_syntax_group =~? 'texMathZone' && nxt_syntax_group !~? 'texMathZone'
    return 's1'
  endif

  if cur_syntax_group =~? 'texMathZone'
    return '='
  endif

  " === Folding HTML comments ===
  if cur_syntax_group =~? 'htmlComment' && prv_syntax_group !~? 'htmlComment'
    return 'a1'
  endif

  if nxt_syntax_group =~? 'htmlComment'
    return '='
  endif

  if prv_syntax_group =~? 'htmlComment' && cur_line !~? 'htmlComment'
    return 's1'
  endif

  " folding setex headers
  if (match(cur_line, '^.*$') >= 0)
    if (match(nxt_line, '^=\+$') >= 0)
      return '>1'
    endif
    if (match(nxt_line, '^-\+$') >= 0)
      return '>2'
    endif
  endif

  return '='

endfunction

function! s:SyntaxGroupOfLineIs(lnum, pattern)
  let stack = synstack(a:lnum, a:cnum)
  if len(stack) > 0
    return synIDattr(stack[0], 'name') =~? a:pattern
  endif
  return 0
endfunction

" }}}

" vim:foldmethod=indent

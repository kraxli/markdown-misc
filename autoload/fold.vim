
" indent('.') / indent(line(.))
" synIDattr(synID(line('.'), 1, 1), 'name')
" foldlevel('.') / foldlevel(line('.'))
" help:
"   http://vimdoc.sourceforge.net/htmldoc/fold.html#folds
"   http://vimdoc.sourceforge.net/htmldoc/usr_41.html

" {{{ FOLDING

let s:pattern_header = '^#\{1,6}\s'

function! fold#FoldLevelOfLine(lnum)
  let currentline = getline(a:lnum)
  let nextline = getline(a:lnum + 1)
  let prevline =  getline(a:lnum - 1)

  let prev_line_syntax_group = synIDattr(synID(a:lnum - 1, 1, 1), 'name')
  let current_line_syntax_group = synIDattr(synID(a:lnum, 1, 1), 'name')  " s:SyntaxGroupOfLineIs(a:lnum, '^markdownListItem')
  let next_line_syntax_group = synIDattr(synID(a:lnum + 1, 1, 1), 'name')

  " an empty line is not going to change the indentation level
  if match(currentline, '^\s*$') >= 0
    return '='
  endif

  " ------- folding atx headers ------
  if match(currentline, s:pattern_header) >= 0
    let header_level = strlen(substitute(currentline, '^\(#\{1,6}\).*', '\1', ''))
    return '>' . header_level
  endif


  " ---------- Folding Lists -----------
  " " folding lists (from gabriel/vim-markdown)
  " if s:SyntaxGroupOfLineIs(a:lnum, '^markdownListItem')
  "   if s:SyntaxGroupOfLineIs(a:lnum - 1, '^markdownListItem')
  "     return 'a1'
  "   endif
  "   if s:SyntaxGroupOfLineIs(a:lnum + 1, '^markdownListItem')
  "     return 's1'
  "   endif
  "   return '='
  " endif
  "
  " " we are not going to fold things inside list items, too hairy
  " let is_inside_a_list_item = s:SyntaxGroupOfLineIs(a:lnum, '^markdownListItem')
  " if is_inside_a_list_item
  "   return '='
  " endif

  if current_line_syntax_group =~? 'mkdListItem'

    let cur_indent = indent(a:lnum)

    " initial list indent level / each new list starts after an empty line
    " or a header (consistent with pandoc)
    if match(prevline, '^\s*$') >= 0 || match(prevline, s:pattern_header)>=0
      let s:list_indent_ini = cur_indent
      let s:list_foldlevel_ini = foldlevel(a:lnum-1)
      " return '='
    endif

    " let prv_foldlevel = foldlevel(a:lnum-1)
    let cur_foldlevel = s:list_foldlevel_ini + (cur_indent - s:list_indent_ini)/&shiftwidth
    " let nxt_foldlevel = s:list_foldlevel_ini + (indent(a:lnum+1) - s:list_indent_ini)/&shiftwidth

    " TODO delete:
    let g:list_foldlevel_ini = s:list_foldlevel_ini
    let g:nxt_foldlevel = nxt_foldlevel
    let g:list_indent_ini = s:list_indent_ini

    return '>' . (cur_foldlevel + 1)

    " if prv_foldlevel < cur_foldlevel
    "   return '>' . (cur_foldlevel - prv_foldlevel)
    " elseif nxt_foldlevel < cur_foldlevel
    "   return '>' . (cur_foldlevel - nxt_foldlevel)
    " " elseif 
    "   " return '='
    " endif

    " return '>' . cur_foldlevel

    " " if next_line_indent > s:list_indent_ini
    "   " return s:list_foldlevel_ini
    " if next_line_indent > cur_indent
    "   return 'a1'
    "   " return '>' . (prv_foldlevel+1)
    " elseif prev_line_indent > cur_indent
    "   return 's' " . (prv_foldlevel-1)
    "   "  (s:list_foldlevel_ini + ((cur_indent-s:list_indent_ini)/&shiftwidth) )
    " elseif cur_indent == s:list_indent_ini
    "   return s:list_foldlevel_ini
    " " elseif prev_line_indent == cur_indent
    " " else
    "   " return '='
    " endif
    "
    " let prev_line_indent = indent(a:lnum-1)
    " let next_line_indent = indent(a:lnum+1)

    " let indent_diff_2ini = cur_indent - s:list_indent_ini
    " let indent_level_change = indent_diff_2ini/&shiftwidth  " float2nr(floor())
    "
    "
    " if indent_diff_2ini > 0
    "   " return 'a' . indent_level_change " string()
    "   return '>' . (s:list_foldlevel_ini + indent_level_change)
    " " elseif indent_diff_2ini < 0
    " "   " return 's' . indent_level_change " s1, s2, ... applies to next line
    " "   return '>' .
    " else
    "   return '='
    " endif

    return '='
  endif

  " === Folding Code ===
  if current_line_syntax_group =~ 'mkdCodeStart'
    return 'a1'
  endif

  " if prev_line_syntax_group ==# 'mkdCodeEnd'
  if current_line_syntax_group =~ 'mkdCodeEnd'
    return 's1'
  endif

  if current_line_syntax_group =~ 'mkdSnippet'
    return '='
  endif

  " folding fenced code blocks
  if match(currentline, '^\s*```') >= 0
    if next_line_syntax_group ==? 'markdownFencedCodeBlock' || next_line_syntax_group =~? 'mkdCode' || next_line_syntax_group =~? 'mkdSnippet'
      return 'a1'
    endif
    return 's1'
  endif

  " folding code blocks
  if match(currentline, '^\s\{4,}') >= 0
    if current_line_syntax_group ==? 'markdownCodeBlock'
      if prev_line_syntax_group !=? 'markdownCodeBlock'
        return 'a1'
      endif
      if next_line_syntax_group !=? 'markdownCodeBlock'
        return 's1'
      endif
    endif
    return '='
  endif

  " === Folding Math ===
  if current_line_syntax_group =~? 'texMathZone' && prev_line_syntax_group !~? 'texMathZone'
    return 'a1'
  endif

  if next_line_syntax_group =~? 'texMathZone'
    return '='
  endif

  if prev_line_syntax_group =~? 'texMathZone' && currentline !~? 'texMathZone'
    return 's1'
  endif

  " === Folding HTML comments ===
  if current_line_syntax_group =~? 'htmlComment' && prev_line_syntax_group !~? 'htmlComment'
    return 'a1'
  endif

  if next_line_syntax_group =~? 'htmlComment'
    return '='
  endif

  if prev_line_syntax_group =~? 'htmlComment' && currentline !~? 'htmlComment'
    return 's1'
  endif

  " folding setex headers
  if (match(currentline, '^.*$') >= 0)
    if (match(nextline, '^=\+$') >= 0)
      return '>1'
    endif
    if (match(nextline, '^-\+$') >= 0)
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

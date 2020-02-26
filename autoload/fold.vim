
" indent('.') / indent(line(.))
" synIDattr(synID(line('.'), 1, 1), 'name')
" foldlevel('.') / foldlevel(line('.'))
" help: http://vimdoc.sourceforge.net/htmldoc/fold.html#folds

" {{{ FOLDING

function! fold#FoldLevelOfLine(lnum)
  let currentline = getline(a:lnum)
  let nextline = getline(a:lnum + 1)
  let prevline =  getline(a:lnum - 1)

  let prev_line_syntax_group = synIDattr(synID(a:lnum - 1, 1, 1), 'name')
  let current_line_syntax_group = synIDattr(synID(a:lnum, 1, 1), 'name')
  let next_line_syntax_group = synIDattr(synID(a:lnum + 1, 1, 1), 'name')

  " an empty line is not going to change the indentation level
  if match(currentline, '^\s*$') >= 0
    return '='
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

  if current_line_syntax_group =~ 'mkdListItem' && prev_line_syntax_group !~ 'mkdListItem'
    return '='
  endif

  if current_line_syntax_group =~ 'mkdListItem' " && next_line_syntax_group =~ 'mkdListItem'
    let current_line_indent = indent(a:lnum)

    let indent_diff_next_line = current_line_indent - indent(a:lnum+1)
    if indent_diff_next_line > 0
      let reduce_indent_level = indent_diff_next_line/&shiftwidth
      if reduce_indent_level < 1
        let reduce_indent_level = 1
      end

      return 's' . reduce_indent_level " s1, s2, ... applies to next line
    endif

    let indent_diff_prev_line = current_line_indent - indent(a:lnum-1)
    if indent_diff_prev_line > 0
      let increase_indent_level = indent_diff_prev_line/&shiftwidth
      if increase_indent_level < 1
        let increase_indent_level = 1
      end

      return 'a' . increase_indent_level
    endif

  endif

    " ------- folding atx headers ------
  if match(currentline, '^#\{1,6}\s') >= 0
    let header_level = strlen(substitute(currentline, '^\(#\{1,6}\).*', '\1', ''))
    return '>' . header_level
  endif


  " let prev_line_syntax_group = synIDattr(synID(a:lnum - 1, 1, 1), 'name')
  " let current_line_syntax_group = synIDattr(synID(a:lnum, 1, 1), 'name')
  " let next_line_syntax_group = synIDattr(synID(a:lnum + 1, 1, 1), 'name')
  "
  " === Folding Math ===
  if current_line_syntax_group =~ 'texMathZone' && prev_line_syntax_group !~ 'texMathZone'
    return 'a1'
  endif

  if next_line_syntax_group =~ 'texMathZone'
    return '='
  endif

  if prev_line_syntax_group =~ 'texMathZone' && currentline !~ 'texMathZone'
    return 's1'
  endif

  " === Folding HTML comments ===
  if current_line_syntax_group =~ 'htmlComment' && prev_line_syntax_group !~ 'htmlComment'
    return 'a1'
  endif

  if next_line_syntax_group =~ 'htmlComment'
    return '='
  endif

  if prev_line_syntax_group =~ 'htmlComment' && currentline !~ 'htmlComment'
    return 's1'
  endif


  " === Folding Code ===
  if current_line_syntax_group ==# 'mkdCodeStart'
    return 'a1'
  endif

  " if prev_line_syntax_group ==# 'mkdCodeEnd'
  if current_line_syntax_group ==# 'mkdCodeEnd'
    return 's1'
  endif

  if current_line_syntax_group =~ 'mkdSnippet'
    return '='
  endif

  " folding fenced code blocks
  if match(currentline, '^\s*```') >= 0
    if next_line_syntax_group ==# 'markdownFencedCodeBlock' || next_line_syntax_group =~ 'mkdCode' || next_line_syntax_group =~ 'mkdSnippet'
      return 'a1'
    endif
    return 's1'
  endif

  " folding code blocks
  if match(currentline, '^\s\{4,}') >= 0
    if current_line_syntax_group ==# 'markdownCodeBlock'
      if prev_line_syntax_group !=# 'markdownCodeBlock'
        return 'a1'
      endif
      if next_line_syntax_group !=# 'markdownCodeBlock'
        return 's1'
      endif
    endif
    return '='
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
    return synIDattr(stack[0], 'name') =~# a:pattern
  endif
  return 0
endfunction

" }}}

" vim:foldmethod=indent

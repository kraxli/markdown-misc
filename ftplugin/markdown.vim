

if !exists('g:markdown_mapping_switch_status')
  let g:markdown_mapping_switch_status = '<c-space>'
endif

if !exists('g:markdown_rxHeader')
  let g:markdown_rxHeader = '#'
endif

if !exists('g:markdown_rxListItem')
  let g:markdown_rxListItem = '^\s*[*-]\s'
endif

if !exists('g:markdown_enable_folding')
  let g:markdown_enable_folding = 0
endif



let g:vimwiki_rxPreStart = '```'
let g:vimwiki_rxPreEnd = '```'


" Switch status of things
execute 'nnoremap <silent> <buffer> ' . g:markdown_mapping_switch_status . ' :call markdown#ToggleStatus()<CR>'


" {{{ OPTIONS

setlocal comments+=b:*,b:-,b:+,n:>,se:``` commentstring=>\ %s
setlocal formatoptions=tron
setlocal formatlistpat=^\\s*\\d\\+\\.\\s\\+\\\\|^\\s*[+-\\*]\\s\\+
setlocal nolisp
setlocal autoindent

" Enable spelling and completion based on dictionary words
" if &spelllang !~# '^\s*$' && g:markdown_enable_spell_checking
"   setlocal spell
" endif

" Custom dictionary for emoji
execute 'setlocal dictionary+=' . shellescape(expand('<sfile>:p:h:h')) . '/dict/emoticons.dict'
setlocal iskeyword+=:,+,-
setlocal complete+=k

" " if g:markdown_enable_input_abbreviations
"   " Replace common ascii emoticons with supported emoji
"   iabbrev <buffer> :-) :smile:
"   iabbrev <buffer> :-D :laughing:
"   iabbrev <buffer> :-( :disappointed:
"
"   " Replace common punctuation
"   iabbrev <buffer> ... …
"   iabbrev <buffer> << «
"   iabbrev <buffer> >> »
" " endif

" Folding
if g:markdown_enable_folding
  setlocal foldmethod=expr
  setlocal foldexpr=fold#FoldLevelOfLine(v:lnum)
endif
" }}}
"
" " {{{ FOLDING
"
" function! FoldLevelOfLine(lnum)
"   let currentline = getline(a:lnum)
"   let nextline = getline(a:lnum + 1)
"   echo currentline
"
"   " an empty line is not going to change the indentation level
"   if match(currentline, '^\s*$') >= 0
"     return '='
"   endif
"
"   " folding lists
"   if s:SyntaxGroupOfLineIs(a:lnum, '^markdownListItem')
"     if s:SyntaxGroupOfLineIs(a:lnum - 1, '^markdownListItem')
"       return 'a1'
"     endif
"     if s:SyntaxGroupOfLineIs(a:lnum + 1, '^markdownListItem')
"       return 's1'
"     endif
"     return '='
"   endif
"
"   " we are not going to fold things inside list items, too hairy
"   let is_inside_a_list_item = s:SyntaxGroupOfLineIs(a:lnum, '^markdownListItem')
"   if is_inside_a_list_item
"     return '='
"   endif
"
"   " folding atx headers
"   if match(currentline, '^#\{1,6}\s') >= 0
"     echo 'folding atx headers'
"     let header_level = strlen(substitute(currentline, '^\(#\{1,6}\).*', '\1', ''))
"     return '>' . header_level
"   endif
"
"   " folding fenced code blocks
"   let next_line_syntax_group = synIDattr(synID(a:lnum + 1, 1, 1), 'name')
"   if match(currentline, '^\s*```') >= 0
"     if next_line_syntax_group ==# 'markdownFencedCodeBlock'
"       return 'a1'
"     endif
"     return 's1'
"   endif
"
"   " folding code blocks
"   let current_line_syntax_group = synIDattr(synID(a:lnum, 1, 1), 'name')
"   let prev_line_syntax_group = synIDattr(synID(a:lnum - 1, 1, 1), 'name')
"   if match(currentline, '^\s\{4,}') >= 0
"     if current_line_syntax_group ==# 'markdownCodeBlock'
"       if prev_line_syntax_group !=# 'markdownCodeBlock'
"         return 'a1'
"       endif
"       if next_line_syntax_group !=# 'markdownCodeBlock'
"         return 's1'
"       endif
"     endif
"     return '='
"   endif
"
"   " folding setex headers
"   if (match(currentline, '^.*$') >= 0)
"     if (match(nextline, '^=\+$') >= 0)
"       return '>1'
"     endif
"     if (match(nextline, '^-\+$') >= 0)
"       return '>2'
"     endif
"   endif
"
"   return '='
" endfunction
"
" function! s:SyntaxGroupOfLineIs(lnum, pattern)
"   let stack = synstack(a:lnum, a:cnum)
"   if len(stack) > 0
"     return synIDattr(stack[0], 'name') =~# a:pattern
"   endif
"   return 0
" endfunction
"
" " }}}
" function! FoldMd()
"   call FoldLevelOfLine(v:lnum)
" endfunction
"



if !exists('g:markdown_mapping_switch_status')
  let g:markdown_mapping_switch_status = '<c-space>'
endif

if !exists('g:markdown_wiki_index_key')
  let g:markdown_wiki_index_key = '<leader>W'
endif

if !exists('g:markdown_blog_index_key')
  let g:markdown_blog_index_key = '<leader>B'
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

execute 'nnoremap <silent> <buffer> ' . g:markdown_wiki_index_key . ' :e ' . g:wiki_dir . ' index.md<CR>'

execute 'nnoremap <silent> <buffer> ' . g:markdown_blog_index_key . ' :e ' . g:blog_dir . ' index.md<CR>'


" ------- Folding -------
if g:markdown_enable_folding
  setlocal foldmethod=expr
  setlocal foldexpr=fold#FoldLevelOfLine(v:lnum)
endif


" --------------------------------------------------
" {{{ OPTIONS
" --------------------------------------------------

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



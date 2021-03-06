

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

if !exists('g:wiki_dir')
  let g:wiki_dir = '~/wiki/'
endif

if !exists('g:blog_dir')
  let g:blog_dir =  '~/blog/'
endif

" Switch status of things
" TODO allow for ranges
" command! -buffer -range ToggleStatus call markdown#ToggleStatus()
command! ToggleStatus call markdown#ToggleStatus()
command! TasksOpen call tools#unfold_open_tasks()
command! TasksOpenHi silent :let @/='^\s*-\s\[\s\]'|set hls


augroup markdown_cmd
  autocmd!
  if !hasmapto('ToggleStatus')
    " TODO let filetype list be determined by the user via a variable
    au Filetype markdown,text
      \ execute 'nnoremap <silent> <buffer> ' . g:markdown_mapping_switch_status . ' :ToggleStatus<cr>'
      \ | execute 'vnoremap <silent> <buffer> ' . g:markdown_mapping_switch_status . ' :ToggleStatus<cr>'
      "\ execute 'nnoremap <silent> <buffer> ' . g:markdown_mapping_switch_status . ' :call markdown#ToggleStatus()<CR>'
  endif

  if !hasmapto('TaksOpenHi')
    nmap <silent> th :TasksOpenHi<cr>
  endif

  if !hasmapto('TasksOpen')
    nmap <silent> to :TasksOpen<cr>
  endif

  au Filetype markdown,text
    \ execute 'nnoremap <silent> <buffer> ' . g:markdown_wiki_index_key . ' :e ' . g:wiki_dir . ' index.md<CR>'

  au Filetype markdown,text
    \ execute 'nnoremap <silent> <buffer> ' . g:markdown_blog_index_key . ' :e ' . g:blog_dir . ' index.md<CR>'

augroup END

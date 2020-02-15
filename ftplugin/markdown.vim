

if !exists('g:markdown_mapping_switch_status')
  let g:markdown_mapping_switch_status = '<c-space>'
endif

" Switch status of things
execute 'nnoremap <silent> <buffer> ' . g:markdown_mapping_switch_status . ' :call markdown#ToggleStatus()<CR>'


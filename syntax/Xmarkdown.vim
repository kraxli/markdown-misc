"
" syn region markdownFencedCodeBlock matchgroup=markdownCodeDelimiter start=/^\s\{,3}```\%(`*\).*$/ end=/^\s\{,3}```\%(`*\)\s*$/ contains=@NoSpell
" syn region markdownFencedCodeBlock matchgroup=markdownCodeDelimiter start=/^\s\{,3}\~\~\~\%(\~*\).*$/ end=/^\s\{,3}\~\~\~\%(\~*\)\s*$/ contains=@NoSpell
"
" syn match markdownCodeBlock /\%(^\n\)\@<=\%(\%(\s\{4,}\|\t\+\).*\n\)\+$/ contains=@NoSpell
"




function tools#unfold_open_tasks()
  " execute "normal! zM"
  " execute "g/^\\s*[-+\\*]\\{1}\\s\\[\\s\\]/normal! zv"
  " If you want all subfolds opened as well, use normal! zvzO instead

  execute "Fp ^\\s*[-+\\*]\\{1}\\s\\[\\s\\]"
endfunction





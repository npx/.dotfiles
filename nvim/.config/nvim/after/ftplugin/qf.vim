nnoremap <buffer> <silent> dd
  \ mj
  \ <Cmd>call setqflist(filter(getqflist(), {idx -> idx != line('.') - 1}), 'r')<CR>
  \ 'j



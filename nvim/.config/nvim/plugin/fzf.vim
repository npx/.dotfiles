" ctrl+p for fuzzy file search
nnoremap <C-p> :FZF<CR>

let g:fzf_action = {
  \ 'ctrl-s': 'split',
  \ 'ctrl-v': 'vsplit'
  \}

autocmd BufLeave *#FZF :bd!

let $FZF_DEFAULT_COMMAND = 'ag -g ""'

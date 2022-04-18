nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

nnoremap <C-p> :lua require('telescope.builtin').git_files()<CR>

nnoremap <leader>vrc :lua require('npx.telescope').search_dotfiles()<CR>
nnoremap <leader>gc :lua require('npx.telescope').git_branches()<CR>

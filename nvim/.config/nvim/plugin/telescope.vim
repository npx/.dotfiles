nnoremap <leader>ff <cmd>lua require('telescope.builtin').find_files()<cr>
nnoremap <leader>fg <cmd>lua require('telescope.builtin').live_grep()<cr>
nnoremap <leader>fb <cmd>lua require('telescope.builtin').buffers()<cr>
nnoremap <leader>fh <cmd>lua require('telescope.builtin').help_tags()<cr>

nnoremap <leader>ds <cmd>lua require('telescope.builtin').lsp_document_symbols()<cr>
nnoremap <leader>ws <cmd>lua require('telescope.builtin').treesitter()<cr>

nnoremap <C-p> :lua require('npx.telescope').project_files()<CR>

nnoremap <leader>vrc :lua require('npx.telescope').search_dotfiles()<CR>
nnoremap <leader>gc :lua require('npx.telescope').git_branches()<CR>

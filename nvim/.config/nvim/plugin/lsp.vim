set completeopt=menu,menuone,noselect

nnoremap <leader>vd :lua vim.lsp.buf.definition()<CR>
nnoremap <leader>vrr :lua vim.lsp.buf.references()<CR>
nnoremap <leader>vrn :lua vim.lsp.buf.rename()<CR>
nnoremap <leader>vh :lua vim.lsp.buf.hover()<CR>
nnoremap <leader>vca :lua vim.lsp.buf.code_action()<CR>
nnoremap <leader>vsd :lua vim.diagnostic.open_float(0, {scope="line"})<CR>

nnoremap <leader>vf :lua vim.lsp.buf.formatting()<CR>
nnoremap <leader>vi :lua vim.lsp.buf.implementation()<CR>
nnoremap <leader>vn :lua vim.lsp.diagnostic.goto_next()<CR>
nnoremap <leader>vp :lua vim.lsp.diagnostic.goto_prev()<CR>
nnoremap <leader>vsh :lua vim.lsp.buf.signature_help()<CR>

nnoremap <leader>cn :cnext<CR>
nnoremap <leader>cp :cprev<CR>

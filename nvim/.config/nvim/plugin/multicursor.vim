" multicursor moves
" Replace selected characters, saving the word to which they belong
xnoremap <leader>ss "sy:let @w='\<'.expand('<cword>').'\>' <bar> let @/=@s<CR>cgn

" Search and replace previously replaced characters
" -> Use the dot ('.') command

" Search and replace the characters if they appear within the same word
" (not working?)
nnoremap <C-s> /<C-r>w<CR><left>/<C-r>s<CR>.

" Search for the next occurrence of the saved word (skip replace)
nnoremap <C-n> /<C-r>w<CR>

" Replace full word
nnoremap <leader>sr :let @/='\<'.expand('<cword>').'\>'<CR>cgn

" Append to the end of a word
nnoremap <leader>sa :let @/='\<'.expand('<cword>').'\>'<CR>cgn<C-r>"

" Macro Replay on matches
let g:mc = "y/\\V\<C-r>=escape(@\", '/')\<CR>\<CR>"

function! SetupCR()
  nnoremap <Enter> :nnoremap <lt>Enter> n@z<CR>q:<C-u>let @z=strpart(@z,0,strlen(@z)-1)<CR>n@z
endfunction

nnoremap <leader>sm :call SetupCR()<CR>*``qz
vnoremap <expr> cq ":\<C-u>call SetupCR()\<CR>" . "gv" . g:mc . "``qz"

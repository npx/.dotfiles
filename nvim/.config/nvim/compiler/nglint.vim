if exists("current_compiler")
	finish
endif

let current_compiler = "nglint"

set makeprg=npx\ ng\ lint
"
" CompilerSet errorformat=%EError:\ %f:%l:%c\ -\ %m,%-G%.%#
" " Note: Eslint compact efm has been sourced from https://github.com/vim/vim/blob/master/runtime/compiler/eslint.vim and contributed by /u/-romainl-
" " Eslint --format compact
" CompilerSet errorformat=%f:\ line\ %l\\,\ col\ %c\\,\ %m,%-G%.%#

" Eslint --format stylish
CompilerSet errorformat^=%-P%f,
		\%\\s%#%l:%c\ %#\ %trror\ \ %m,
		\%\\s%#%l:%c\ %#\ %tarning\ \ %m,
		\%-Q,
		\%-G%.%#,

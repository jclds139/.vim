"sets colorscheme default with a few color customizations

highlight clear
if exists("syntax_on")
	syntax reset
endif


runtime colors/default.vim

let g:colors_name = "my-default"

highlight clear Normal
highlight Normal guifg=#00c8ff guibg=black

set background=dark " for whatever reason, this does nothing


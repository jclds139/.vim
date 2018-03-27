set number
set bg=dark
set showcmd
set incsearch
set hlsearch
set autoindent
set nocompatible
set wrap
set spelllang=en_us
set textwidth=0
set laststatus=2
set confirm
syntax on


let g:airline_skip_empty_sections = 1
let g:airline_detect_spell = 1
let g:airline_symbols_ascii = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1

let g:eldar_text = '#00C8FF'
let g:eldar_cyan = '#507070'
let g:eldar_magenta = 'magenta'

let &directory = $MYVIMRC[:-6] . 'swaps//'

if has("win32") || has("win64")
	"taken from gVim Portable on Windows default _vimrc
	behave mswin
	
	set diffexpr=MyDiff()
	function MyDiff()
	  let opt = '-a --binary '
	  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
	  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
	  let arg1 = v:fname_in
	  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
	  let arg2 = v:fname_new
	  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
	  let arg3 = v:fname_out
	  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
	  let eq = ''
	  if $VIMRUNTIME =~ ' '
	    if &sh =~ '\<cmd'
	      let cmd = '""' . $VIMRUNTIME . '\diff"'
	      let eq = '"'
	    else
	      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
	    endif
	  else
	    let cmd = $VIMRUNTIME . '\diff'
	  endif
	  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
	endfunction

endif

"sets the font based on OS (if its not Windows or Unix-compatible, dump to default)
if has("gui_running") "only for gui sessions
	"colorscheme cyberpunk
	colorscheme eldar

	set guicursor=n-v-c:block-Cursor,i:ver15-Cursor,r:hor10-Cursor
	set guicursor+=a:blinkwait400-blinkon600-blinkoff400,v:blinkoff0

	if has("win32") || has("win64") || has("win16")
		set guifont=Anonymous_Pro:h9,Courier_New:h9
	elseif has("unix")
		if ! filereadable("$HOME/.fonts/Anonymous_Pro/AnonymousPro-Regular.ttf")
			call system("cp -r ~/.vim/fonts/Anonymous_Pro ~/.fonts/")
		endif
		set guifont=Anonymous\ Pro\ 9
	endif

elseif has("unix") && (system("cat /proc/version | grep -cE 3\.4.*Microsoft") == 1)
	"checks for pre-Creators Update Bash on Windows, to manually set t_Co, only when no GUI is running
	set t_Co=16 "override it to be 16
	"the old Windows console (and so the Bash terminal) only had the standard 16 colors
	"from Win10 Creators (1703)+, it theoretically supports 24-bit color, and admits to 256 colors
	colorscheme eldar
else
	colorscheme eldar
endif

"fixes for earlier (pre-8.0) versions of vim which dont have package management
if (v:version < 800) "adds everything to rtp
	for plugin in split(glob($MYVIMRC[:-6] . 'pack/*/start/*'), '\n') "for each plugin found in a 'start' folder
		let &runtimepath.=','.plugin "add it to the runtime path
	endfor
else "for vim 8.0 and later
	packloadall "it just takes one command to do all that, and a better job of it to boot
endif
silent! helptags ALL

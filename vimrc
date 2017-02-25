set number
set showcmd
set incsearch
set hlsearch
set autoindent
set nocompatible

if has("win32") || has("win64")
	"taken from gVim Portable on Windows default _vimrc
	source $VIMRUNTIME/vimrc_example.vim
	source $VIMRUNTIME/mswin.vim
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

	if has("win32") || has("win64") || has("win16")
		set guifont=Anonymous_Pro:h9,Courier_New:h9
	elseif has("unix")
		if ! filereadable("$HOME/.fonts/Anonymous_Pro/AnonymousPro-Regular.ttf")
			call system("cp -r ~/.vim/fonts/Anonymous_Pro ~/.fonts/")
		endif
		set guifont=Anonymous\ Pro\ 9
	endif

	set gcr=sm:bar-Cursor-blink
	set bg=dark
	hi NORMAL guifg=#00C8FF guibg=black
endif

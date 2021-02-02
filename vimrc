set number "duh
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
set backspace=2 "allow generous backspacing on all platforms
set mouse=a "enable mouse by default
syntax on
filetype plugin on


let g:airline_skip_empty_sections = 1
let g:airline_detect_spell = 1
let g:airline_symbols_ascii = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1

let g:tiddlywiki_autoupdate = 1

"Eldar Custom Colors
let g:eldar_text = '#00C8FF'
let g:eldar_cyan = '#507070'
let g:eldar_magenta = 'magenta'

"PlantUML Compile Options
let g:plantuml_set_makeprg=1
let g:plantuml_executable_script="plantuml -tsvg"

"LaTeX Options, for when LaTeX suite is enabled
let g:tex_flavor='latex'
set shellslash

if has('nvim')
	"cut off the 'init.vim'
	let &directory = $MYVIMRC[:-9] . 'swaps//'

	"neovim support cursor spec
	set guicursor=n-v-c:block-Cursor,i:ver15-Cursor,r:hor10-Cursor
	set guicursor+=a:blinkwait400-blinkon600-blinkoff400,v:blinkoff0
else
	"cut off just 'vimrc
	let &directory = $MYVIMRC[:-6] . 'swaps//'
endif

set tags=./tags; "search upward for the tags file, and use its directory

" Auto Update timestamps (@updated:)
" If buffer modified, update any 'Last modified: ' in the first 20 lines.
" 'Last modified: ' can have up to 10 characters before (they are retained).
" Restores cursor and window position using save_cursor variable.
" param: leader contains the text preceeding the timestamp (e.g. 'Last Modified:', etc.)
function! Timestamp(leader)
	if &modified
		let save_cursor = getpos(".")
		let n = min([20, line("$")])
		keepjumps exe '1,' . n . 's#^\(.\{,10}' . a:leader .' \).*#\1' .
					\ strftime('%d %b %Y') . '#e'
		call histdel('search', -1)
		call setpos('.', save_cursor)
	endif
endfunction

autocmd BufWritePre * call Timestamp("[uU]pdated:")
autocmd BufWritePre * call Timestamp("Last Modified:")

function AutoFontHeight()

	if executable("xrandr") "calculate from xrandr
		let l:w_px = system("xrandr | grep primary | awk -F \"[[:space:]]*|x|+|mm\" '{print $4}'")
		let l:h_px = system("xrandr | grep primary | awk -F \"[[:space:]]*|x|+|mm\" '{print $5}'")
		let l:w_mm = system("xrandr | grep primary | awk -F \"[[:space:]]*|x|+|mm\" '{print $(NF-5)}'")
		let l:h_mm = system("xrandr | grep primary | awk -F \"[[:space:]]*|x|+|mm\" '{print $(NF-1)}'")

		if (l:w_mm <= 0)
			let l:dpi_w = 0
		else
			let l:dpi_w = l:w_px/(l:w_mm/25.4)
		endif

		if (l:h_mm <= 0)
			let l:dpi_h = 0
		else
			let l:dpi_h = l:h_px/(l:h_mm/25.4)
		endif

		if (l:dpi_w == 0)
			let l:dpi_w = l:dpi_h
		elseif (l:dpi_h == 0)
			let l:dpi_h = l:dpi_w
		endif

		if (l:dpi_w == 0) "both are 0
			let l:dpi = 0
		else
			let l:dpi = (l:dpi_h+l:dpi_w)/2
		endif
	elseif executable("xdpyinfo") "read dpi directly from the Xserver
		"xdpyinfo tends to lie if any scaling is involved, so let's deprioritize it
		let l:dpi_x = system("xdpyinfo | grep resolution | head -n1 | awk -F \"[[:space:]]+|x\" '{print $3}'")
		let l:dpi_y = system("xdpyinfo | grep resolution | head -n1 | awk -F \"[[:space:]]+|x\" '{print $4}'")
		let l:dpi = (l:dpi_x+l:dpi_y)/2
	else
		let l:dpi = 0
	endif

	if type(l:dpi) == type(1.0) && l:dpi > 0
		return 11+trunc((l:dpi-96)/20)
	else
		return 13
	endif

endfunction

if has("win32") || has("win64")
	"taken from gVim Portable on Windows default _vimrc
	" behave mswin "- this does things I don't like

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

function NvimFont(height)
	if exists('g:GtkGuiLoaded') "for neovim-gtk
		call rpcnotify(1, 'Gui', 'Font', 'Anonymous Pro ' . string(a:height) )
		call rpcnotify(1, 'Gui', 'Tabline', 0)
		call rpcnotify(1, 'Gui', 'Popupmenu', 0)
	else "for nvim-qt
		exe ':set guifont=Anonymous\ Pro:h' . string(a:height)
	endif
endfunction

if exists('g:started_by_firenvim')
	let g:firenvim_config = { 
			\ 'globalSettings': {
				\ 'alt': 'all',
			\  },
			\ 'localSettings': {
				\ '.*': {
					\ 'content': 'text',
					\ 'priority': 0,
					\ 'takeover': 'never',
					\ 'selector': 'textarea,input',
					\ 'cmdline': 'neovim'
				\ }
			\ }
		\ }

	au BufEnter localhost__*-SPAN-*-DIV-*.txt set filetype=tiddlywiki spell linebreak

	" exe "set lines=" . trim(string(round(&lines*10/AutoFontHeight())), '.0')
	" exe "set columns=" . trim(string(round(&columns*10/AutoFontHeight())), '.0')
	let g:gui_running = v:true
endif

"sets the font based on OS (if its not Windows or Unix-compatible, dump to default)
if has("gui_running") || exists('g:gui_running') "only for gui sessions
	"colorscheme cyberpunk
	colorscheme eldar

	set guicursor=n-v-c:block-Cursor,i:ver15-Cursor,r:hor10-Cursor
	set guicursor+=a:blinkwait400-blinkon600-blinkoff400,v:blinkoff0

	if has("win32") || has("win64") || has("win16")
		if has("nvim")
			call NvimFont(14)
		else
			set guifont=Anonymous_Pro:h12,Courier_New:h12,Courier:h12
		endif
	elseif has("unix")
		if ! filereadable("$HOME/.fonts/Anonymous_Pro/AnonymousPro-Regular.ttf")
			call system("cp -r ~/.vim/fonts/Anonymous_Pro ~/.fonts/")
		endif

		if has("nvim")
			call NvimFont(AutoFontHeight())
		else
			exe ':set guifont=Anonymous\ Pro\ ' . string(AutoFontHeight())
		endif
	endif

elseif has("unix") && (system("cat /proc/version | grep -cE 3\.4.*Microsoft") == 1)
	"checks for pre-Creators Update Bash on Windows, to manually set t_Co, only when no GUI is running
	set t_Co=16 "override it to be 16
	"the old Windows console (and so the Bash terminal) only had the standard 16 colors
	"from Win10 Creators (1703)+, it theoretically supports 24-bit color, and admits to 256 colors
	colorscheme harlequin
elseif has("nvim")
	if ($COLORTERM == "truecolor" || has("termguicolors"))
		set termguicolors
		colorscheme eldar
	else
		colorscheme harlequin
	endif
else
	colorscheme harlequin
endif

"fixes for earlier (pre-8.0) versions of vim which don't have package management
if (v:version < 800) "adds everything to rtp
	for plugin in split(glob($MYVIMRC[:-6] . 'pack/*/start/*'), '\n') "for each plugin found in a 'start' folder
		let &runtimepath.=','.plugin "add it to the runtime path
	endfor
else "for vim 8.0 and later
	packloadall "it just takes one command to do all that, and a better job of it to boot
endif

"F5 Compiling - especially handy for linting and PlantUML - but don't override
"plugins' mappings
nnoremap <F5> :w<CR> :silent make<CR>
inoremap <F5> <Esc>:w<CR>:silent make<CR>
vnoremap <F5> :<C-U>:w<CR>:silent make<CR


"extensions setup for CoC
if exists(":CocInfo")
	" base set of extensions to install always
	let g:coc_global_extensions = ['coc-json',
		\ 'coc-snippets',
		\ 'coc-tag',
		\ 'coc-word',
		\ 'coc-dictionary',
		\ 'coc-python',
		\ 'coc-diagnostic',
		\ 'coc-syntax',
		\ 'coc-yank',
		\ 'coc-sh',
		\ 'coc-git',
		\ 'coc-highlight']
	" if hidden is not set, TextEdit might fail.
	set hidden

	" Some servers have issues with backup files, see #649
	set nobackup
	set nowritebackup
	" You will have bad experience for diagnostic messages when it's default 4000.
	set updatetime=300

	" don't give |ins-completion-menu| messages.
	set shortmess+=c

	" Always show the signcolumn, otherwise it would shift the text each time
	" diagnostics appear/become resolved.
	if has("patch-8.1.1564")
		" Recently vim can merge signcolumn and number column into one
		set signcolumn=number
	else
		set signcolumn=yes
	endif

	" Use tab for trigger completion with characters ahead and navigate.
	" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
	" other plugin before putting this into your config.
	inoremap <silent><expr> <TAB>
				\ pumvisible() ? "\<C-n>" :
				\ <SID>check_back_space() ? "\<TAB>" :
				\ coc#refresh()
	inoremap <expr><S-TAB> pumvisible() ? "\<C-p>" : "\<C-h>"

	function! s:check_back_space() abort
		let col = col('.') - 1
		return !col || getline('.')[col - 1]  =~# '\s'
	endfunction

	" Use <cr> to confirm completion, `<C-g>u` means break undo chain at current
	" position. Coc only does snippet and additional edit on confirm.
	" <cr> could be remapped by other vim plugin, try `:verbose imap <CR>`.
	if exists('*complete_info')
		inoremap <expr> <cr> complete_info()["selected"] != "-1" ? "\<C-y>" : "\<C-g>u\<CR>"
	else
		inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
	endif

	" Use `[g` and `]g` to navigate diagnostics
	" Use `:CocDiagnostics` to get all diagnostics of current buffer in location list.
	nmap <silent> [g <Plug>(coc-diagnostic-prev)
	nmap <silent> ]g <Plug>(coc-diagnostic-next)

	" GoTo code navigation.
	nmap <silent> gd <Plug>(coc-definition)
	nmap <silent> gy <Plug>(coc-type-definition)
	nmap <silent> gi <Plug>(coc-implementation)
	nmap <silent> gr <Plug>(coc-references)

	" Use K to show documentation in preview window.
	nnoremap <silent> K :call <SID>show_documentation()<CR>

	function! s:show_documentation()
		if (index(['vim','help'], &filetype) >= 0)
			execute 'h '.expand('<cword>')
		else
			call CocActionAsync('doHover')
		endif
	endfunction

	" Symbol renaming.
	nmap <leader>rn <Plug>(coc-rename)

	" Add `:Format` command to format current buffer.
	command! -nargs=0 Format :call CocAction('format')

	" Add `:Fold` command to fold current buffer.
	command! -nargs=? Fold :call     CocAction('fold', <f-args>)

	" Remap keys for applying codeAction to the current buffer.
	nmap <leader>ac  <Plug>(coc-codeaction)
	" Apply AutoFix to problem on the current line.
	nmap <leader>qf  <Plug>(coc-fix-current)

	" Mappings for CoCList
	" Show all diagnostics.
	nnoremap <silent><nowait> <space>a  :<C-u>CocList diagnostics<cr>
	" Manage extensions.
	nnoremap <silent><nowait> <space>e  :<C-u>CocList extensions<cr>
	" Show commands.
	nnoremap <silent><nowait> <space>c  :<C-u>CocList commands<cr>
	" Find symbol of current document.
	nnoremap <silent><nowait> <space>o  :<C-u>CocList outline<cr>
	" Search workspace symbols.
	nnoremap <silent><nowait> <space>s  :<C-u>CocList -I symbols<cr>
	" Do default action for next item.
	nnoremap <silent><nowait> <space>j  :<C-u>CocNext<CR>
	" Do default action for previous item.
	nnoremap <silent><nowait> <space>k  :<C-u>CocPrev<CR>
	" Resume latest coc list.
	nnoremap <silent><nowait> <space>p  :<C-u>CocListResume<CR>
endif

silent! helptags ALL

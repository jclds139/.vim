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
let g:airline_highlighting_cache = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_nr_show = 1
let g:airline#extensions#coc#enabled = 1
let g:airline#extensions#virtualenv#enabled = 1
let g:airline#extensions#tagbar#enabled = 0
let g:airline#extensions#searchcount#enabled = 0


let g:tiddlywiki_autoupdate = 1

"Eldar Custom Colors
let g:eldar_text = '#00C8FF'
let g:eldar_cyan = '#507070'
let g:eldar_magenta = 'magenta'

"Moonfly Colorscheme Config
let g:moonflyItalics = v:true
let g:moonflyVirtualTextColor = v:true
let g:moonflyUnderlineMatchParen = v:true
let g:moonflyUndercurls = v:true
let g:moonflyTransparent = v:false
let g:moonflyTerminalColors = v:false

" Vimscript initialization file
augroup moonflyCustom
    autocmd!
    autocmd ColorScheme moonfly highlight Normal guifg=#00c8ff
augroup END

"PlantUML Compile Options
let g:plantuml_set_makeprg=1
let g:plantuml_executable_script="plantuml -tsvg"

"jupytext for ipynb files
let g:jupytext_fmt='py:percent'
let g:jupytext_filetype_map = { 'py:percent': 'python' }

"LaTeX Options, for when LaTeX suite is enabled
let g:tex_flavor='latex'
set shellslash

"netrw browsing
let g:netrw_browse_split = 4

"UltiSnips config
let g:ultisnips_python_style = 'numpy'

"load indent-guides if compatible
if (v:version >= 720) || has("nvim") && !exists('g:vscode')
	packadd indent-guides
endif

"firenvim lazy loading
if exists('g:started_by_firenvim')
	packadd firenvim
endif

if has('nvim')
	"cut off the 'init.vim'
	let &directory = expand('<sfile>:h:p') . '/swaps//'

	"neovim support cursor spec
	set guicursor=n-v-c:block-Cursor,i:ver15-Cursor,r:hor10-Cursor
	set guicursor+=a:blinkwait400-blinkon600-blinkoff400,v:blinkoff0
	if exists('g:vscode')
		let g:coc_start_at_startup = v:false
	endif
else
	"cut off just 'vimrc
	let &directory = expand('<sfile>:h:p') . '/swaps//'
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
		call rpcnotify(1, 'Gui', 'Font', 'Fantasque Sans Mono' . string(a:height) )
		call rpcnotify(1, 'Gui', 'Tabline', 0)
		call rpcnotify(1, 'Gui', 'Popupmenu', 0)
	else "for nvim-qt
		exe 'set guifont=Fantasque\ Sans\ Mono:h' . string(a:height)
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
				\ 'selector': 'textarea:not([readonly]):not([class="handsontableInput"]), div[role="textbox"], input',
				\ 'cmdline': 'neovim'
				\ },
				\ '.*notion\.so.*': { 'priority': 9, 'takeover': 'never', },
				\ '.*docs\.google\.com.*': { 'priority': 9, 'takeover': 'never', },
				\ }
				\ }

	function FireNvimFT()
		let l:markdown_site_pattern = 'git[a-z]\{3}\.com\|stack\(exc\|over\)\|slack.com\|reddit.com'
		let l:jupyter_site_pattern = 'co\(calc\|.*google.*\)\.com\|kaggle.*\.com'

		let l:bufname=expand('%:t')

		if l:bufname =~? l:markdown_site_pattern
			set filetype=markdown linebreak spell
		elseif l:bufname =~? l:jupyter_site_pattern
			set filetype=python
		elseif l:bufname =~? 'localhost'
			set filetype=tiddlywiki linebreak spell
		endif
		endfunction

	autocmd BufReadPost,BufNewFile * call FireNvimFT()

	autocmd UIEnter * call NvimFont(14)


	let g:gui_running = v:true
	set termguicolors
endif

"sets the font based on OS (if its not Windows or Unix-compatible, dump to default)
if has("gui_running") || exists('g:gui_running') "only for gui sessions
	colorscheme moonfly

	set guicursor=n-v-c:block-Cursor,i:ver15-Cursor,r:hor10-Cursor
	set guicursor+=a:blinkwait400-blinkon600-blinkoff400,v:blinkoff0

	if has("win32") || has("win64") || has("win16")
		if has("nvim")
			call NvimFont(14)
		else
			set guifont=Fantasque_Sans_Mono:h14,Anonymous_Pro:h14,Consolas:h14,Courier_New:h14,Courier:h14
		endif
	elseif has("unix")
		if ! filereadable("$HOME/.fonts/Fantasque_Sans_Mono/FantasqueSansMono-Regular.otf")
			call system("cp -r ~/.vim/fonts/Fantasque_Sans_Mono ~/.fonts/")
		endif

		if !exists('g:started_by_firenvim')
			if has("nvim")
				call NvimFont(AutoFontHeight())
			else
				exe 'set guifont=Fantasque\ Sans\ Mono\ ' . string(AutoFontHeight())
			endif
		endif
	endif

elseif has("unix") && (system("cat /proc/version | grep -cE 3\.4.*Microsoft") == 1)
	"checks for pre-Creators Update Bash on Windows, to manually set t_Co, only when no GUI is running
	set t_Co=16 "override it to be 16
	"the old Windows console (and so the Bash terminal) only had the standard 16 colors
	"from Win10 Creators (1703)+, it theoretically supports 24-bit color, and admits to 256 colors
	colorscheme harlequin
elseif has("nvim")
	packadd sphinx.nvim
	packadd treesitter
	runtime ts.lua
	silent TSUpdate
	if ($COLORTERM == "truecolor" || has("termguicolors"))
		set termguicolors
		colorscheme moonfly
	else
		colorscheme eldar
	endif
else
	colorscheme moonfly
endif

"fixes for earlier (pre-8.0) versions of vim which don't have package management
if (v:version < 800) && !has("nvim") "adds everything to rtp
	for plugin in split(glob(expand('<sfile>:p:h') . '/pack/*/start/*'), '\n') "for each plugin found in a 'start' folder
		let &runtimepath.=','.plugin "add it to the runtime path
	endfor
	packadd tcomment "only needed for vanilla vim, not for nvim
elseif exists('g:vscode')
	set noloadplugins
	packadd matchit
	packadd surround
	packadd virtualenv
	packadd fugitive
	packadd airline
	packadd eldar
	packadd moonfly-colors
	packadd matlab-syntax
	let g:clipboard = g:vscode_clipboard
else "for vim 8.0 and later
	packloadall "it just takes one command to do all that, and a better job of it to boot
	packadd tcomment "only needed for vanilla vim, not for nvim
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
				\ 'coc-diagnostic',
				\ 'coc-syntax',
				\ 'coc-yank',
				\ 'coc-git',
				\ 'coc-highlight',
				\ 'coc-marketplace']

	let g:coc_filetype_map = {
				\ 'arduino': 'cpp'
				\ }

	" load UltiSnips with CoC
	if (v:version < 800) && !has("nvim") "adds everything to rtp
		for plugin in split(glob(expand('<sfile>:p:h') . '/pack/syntax/opt/*'), '\n') "for each plugin found in 'syntax/opt' folder
			"that folder should only contain the snippet plugins
			let &runtimepath.=','.plugin "add it to the runtime path
		endfor
	else "for vim 8.0 and later
		packadd vim-snippets
	endif

	" Some servers have issues with backup files, see #649.
	set nobackup
	set nowritebackup

	" Having longer updatetime (default is 4000 ms = 4 s) leads to noticeable
	" delays and poor user experience.
	set updatetime=300

	" Always show the signcolumn, otherwise it would shift the text each time
	" diagnostics appear/become resolved.
	set signcolumn=yes

	" Use tab for trigger completion with characters ahead and navigate.
	" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
	" other plugin before putting this into your config.
	inoremap <silent><expr> <Tab>
				\ coc#pum#visible() ? coc#pum#next(1):
				\ coc#expandableOrJumpable() ? "\<C-r>=coc#rpc#request('doKeymap', ['snippets-expand-jump',''])\<CR>" :
				\ CheckBackspace() ? "\<Tab>" :
				\ coc#refresh()
	inoremap <expr><S-Tab> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"

	" Make <CR> to accept selected completion item or notify coc.nvim to format
	" <C-g>u breaks current undo, please make your own choice.
	inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>"

	function! CheckBackspace() abort
		let col = col('.') - 1
		return !col || getline('.')[col - 1]  =~# '\s'
	endfunction

	" Use <c-space> to trigger completion.
	if has('nvim')
		inoremap <silent><expr> <c-space> coc#pum#visible() ? coc#_select_confirm() : "\<c-space>"
	else
		inoremap <silent><expr> <c-@> coc#pum#visible() ? coc#_select_confirm() : "\<c-@>"
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
	nnoremap <silent> K :call ShowDocumentation()<CR>

	function! ShowDocumentation()
		if CocAction('hasProvider', 'hover')
			call CocActionAsync('doHover')
		else
			call feedkeys('K', 'in')
		endif
	endfunction

	" Symbol renaming.
	nmap <leader>rn <Plug>(coc-rename)

	" Formatting selected code.
	xmap <leader>f  <Plug>(coc-format-selected)
	nmap <leader>f  <Plug>(coc-format-selected)

	" Applying codeAction to the selected region.
	" Example: `<leader>aap` for current paragraph
	xmap <leader>a  <Plug>(coc-codeaction-selected)
	nmap <leader>a  <Plug>(coc-codeaction-selected)

	" Remap keys for applying codeAction to the current buffer.
	nmap <leader>ac  <Plug>(coc-codeaction)
	" Apply AutoFix to problem on the current line.
	nmap <leader>qf  <Plug>(coc-fix-current)

	" Run the Code Lens action on the current line.
	nmap <leader>cl  <Plug>(coc-codelens-action)

	" Remap <C-f> and <C-b> for scroll float windows/popups.
	if has('nvim-0.4.0') || has('patch-8.2.0750')
		nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
		nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
		inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
		inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
		vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
		vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
	endif

	" Use CTRL-S for selections ranges.
	" Requires 'textDocument/selectionRange' support of language server.
	nmap <silent> <C-s> <Plug>(coc-range-select)
	xmap <silent> <C-s> <Plug>(coc-range-select)

	" Add `:Format` command to format current buffer.
	command! -nargs=0 Format :call CocActionAsync('format')

	" Add `:Fold` command to fold current buffer.
	command! -nargs=? Fold :call     CocAction('fold', <f-args>)

	" Add `:OR` command for organize imports of the current buffer.
	command! -nargs=0 OR   :call     CocActionAsync('runCommand', 'editor.action.organizeImport')

	" Add (Neo)Vim's native statusline support.
	" NOTE: Please see `:h coc-status` for integrations with external plugins that
	" provide custom statusline: lightline.vim, vim-airline.
	" set statusline^=%{coc#status()}%{get(b:,'coc_current_function','')}

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

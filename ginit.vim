let g:gui_running=1
let s:config_folder = expand('<sfile>:p:h')
exe 'source ' . s:config_folder . '/init.vim'

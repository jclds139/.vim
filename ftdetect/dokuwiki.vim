" looks for DokuWiki headlines in the first 20 lines
" of the current buffer
fun IsDokuWiki()
  if match(getline(1,20),'^ \=\(=\{2,6}\).\+\1 *$') >= 0
    set textwidth=0
    set wrap
    set linebreak
    set filetype=dokuwiki
    syntax on
  endif
endfun

" check for dokuwiki syntax
autocmd BufWinEnter *.txt call IsDokuWiki()

autocmd BufNewFile,BufRead *.wiki set ft=dokuwiki
autocmd BufNewFile,BufRead *.dokuwiki set ft=dokuwiki

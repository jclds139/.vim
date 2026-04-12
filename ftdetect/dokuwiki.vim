" looks for DokuWiki headlines in the first 20 lines
" of the current buffer
fun SetDokuWiki()
    set textwidth=0
    set wrap
    set linebreak
    set filetype=dokuwiki
    syntax on
endfun

fun IsDokuWiki()
  if &filetype == 'help'
    return
  endif
  if match(getline(1,20),'^ \=\(=\{2,6}\).\+\1 *$') >= 0
    call SetDokuWiki()
  endif
endfun

" check for dokuwiki syntax
autocmd BufWinEnter *.txt call IsDokuWiki()
autocmd BufNewFile,BufRead *.wiki call IsDokuWiki()
autocmd BufNewFile,BufRead *.dokuwiki call SetDokuWiki()
autocmd BufNewFile,BufRead *.dw call SetDokuWiki()


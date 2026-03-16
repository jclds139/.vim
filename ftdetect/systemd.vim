" Vim filetype detection for systemd files
" Unit files
au BufRead,BufNewFile *.service,*.socket,*.timer,*.mount,*.automount,*.swap,*.target,*.path,*.slice,*.scope,*.device setlocal filetype=systemd
" Quadlet files
au BufRead,BufNewFile *.container,*.volume,*.kube,*.pod setlocal filetype=systemd
" systemd-networkd
au BufRead,BufNewFile *.network,*.link,*.netdev,*.dnssd setlocal filetype=systemd

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Syntastic config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nmap <leader>cs :SyntasticCheck<CR>
nmap <leader>rr :SyntasticReset<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 0

let g:syntastic_mode_map = { "mode" : "passive", "active_filetypes" : [], "passive_filetypes": ["tex"] }

" Python
let g:syntastic_python_checkers = ['pylint']
" command! -nargs=1 SyntasticPyVer let g:syntastic_python_python_exec = \"/usr/bin/python" . <args>


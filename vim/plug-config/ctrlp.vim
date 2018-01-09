"Change mapping of CtrlP
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

"When invoked, unless a starting directory is specified,
"CtrlP will set its local working directory according to this variable
let g:ctrlp_working_path_mode = 'ra'

"Exclude files and directories using Vim's wildignore and CtrlP's own g:ctrlp_custom_ignore:
set wildignore+=*/tmp/*,*.so,*.swp,*.zip     " MacOSX/Linux

let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn)$'
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/]\.(git|hg|svn)$',
  \ 'file': '\v\.(exe|so|dll)$',
  \ 'link': 'some_bad_symbolic_links',
  \ }

"Use a custom file listing command:
"let g:ctrlp_user_command = 'find %s -type f'        " MacOSX/Linux

let g:ctrlp_max_depth = 5

let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:10,results:10'

let g:ctrlp_follow_symlinks = 1

"show hidden files
let g:ctrlp_show_hidden = 1

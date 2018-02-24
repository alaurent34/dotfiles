call plug#begin('~/.vim/plugged')

Plug 'vim-scripts/wombat256.vim' 
Plug 'scrooloose/syntastic'
Plug 'Valloric/YouCompleteMe', { 'do' : './install.py --system-libclang --clang-completer --omnisharp-completer' }
Plug 'tpope/vim-fugitive'
Plug 'itchyny/lightline.vim'
Plug 'easymotion/vim-easymotion'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'mileszs/ack.vim'
Plug 'godlygeek/tabular' "Must load before vim-markdown (see :h vim-markdown)

Plug 'tpope/vim-abolish'        "correct typo
Plug 'tpope/vim-surround'       "change surrounding of work \" -> \'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-unimpaired'
Plug 'tpope/vim-speeddating'
Plug 'tpope/vim-rsi'

Plug 'mhinz/vim-startify'
"Plug 'glts/vim-radical' "don't work
Plug 'matze/vim-move' "don't seems to work

Plug 'SirVer/ultisnips'
Plug 'honza/vim-snippets'
Plug 'Raimondi/delimitMate'

call plug#end()

" With a map leader it's possible to do extra key combinations
" like <leader>w saves the current file
let mapleader = ","
let g:mapleader = ","
let g:programming_fts = [
      \ "c",
      \ "cpp",
      \ "python",
      \ "pyrex",
      \ "haskell",
      \ "lua",
      \ "php",
      \ "js",
      \ "html",
      \ "css",
      \ "cs",
      \ "java",
      \ "sh"
      \ ]
let g:syntaxed_fts = g:programming_fts + [
      \ "vim",
      \ "tex",
      \ "mkd",
      \ "markdown",
      \ "rst",
      \ "cmake",
      \ "make"
      \ ]

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable filetype plugins
filetype plugin on
filetype indent on

" :W sudo saves the file 
command! W w !sudo tee % > /dev/null

" Return to last edit position when opening files (You want this!)
au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => VIM user interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set history=500                " Sets how many lines of history VIM has to remember
set autochdir
set autoread                   " Set to auto read when a file is changed from the outside
set so=7                       " Set 7 lines to the cursor - when moving vertically using j/k
let $LANG='en'                 " Avoid garbled characters in Chinese language windows OS
set langmenu=en
set spelllang=fr               " spellcheck language
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
set wildmenu                   " Turn on the WiLd menu
set wildignore=*.o,*~,*.pyc    " Ignore compiled files

if has("win16") || has("win32")
    set wildignore+=.git\*,.hg\*,.svn\*
else
    set wildignore+=*/.git/*,*/.hg/*,*/.svn/*,*/.DS_Store
endif

set ruler                      " Always show current position
set cmdheight=2                " Height of the command bar
set hid                        " A buffer becomes hidden when it is abandoned
set backspace=eol,start,indent " Configure backspace so it acts as it should act
set whichwrap+=<,>,h,l
set ignorecase                 " Ignore case when searching
set smartcase                  " When searching try to be smart about cases
set hlsearch                   " Highlight search results
set incsearch                  " Makes search act like search in modern browsers
set lazyredraw                 " Don't redraw while executing macros (good performance config)
set magic                      " For regular expressions turn magic on
set showmatch                  " Show matching brackets when text indicator is over them
set mat=2                      " How many tenths of a second to blink when matching brackets
set number                     " Enable numbers
set relativenumber             " Enable relative number
set showcmd
set noerrorbells               " No annoying sound on errors
set novisualbell
set t_vb=                      " Disable bell sound                                            "
set tm=500
set laststatus=2               " Always show the status line

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Text, tab and indent related
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab    " Use spaces instead of tabs
set smarttab     " Be smart when using tabs ;)
set shiftwidth=4 " 1 tab == 4 spaces
set tabstop=4
set lbr          " Linebreak on 500 characters
set tw=120
set ai           " Auto indent
set si           " Smart indent
set wrap         " Wrap lines
" set foldcolumn=1 " Add a bit extra margin to the left

" Specify the behavior when switching between buffers 
try
  set switchbuf=useopen,usetab,newtab
  set stal=2
catch
endtry

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Files, backups and undo
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Turn backup off, since most stuff is in SVN, git et.c anyway...
" set nobackup
" set nowb
" set noswapfile

""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Colorsheme and Fonts
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Enable syntax highlighting
syntax enable 

" Enable 256 colors palette in Gnome Terminal
if $COLORTERM == 'gnome-terminal'
    set t_Co=256
endif

"TODO check pour mettre solarized en terminal
"let g:solarized_termcolors=256

try
    colorscheme wombat256mod
catch
endtry

set background=dark

" Set extra options when running in GUI mode
if has("gui_running")
    set guioptions-=T
    set guioptions-=e
    set t_Co=256
    set guitablabel=%M\ %t
endif

set encoding=utf8    " Set utf8 as standard encoding and en_US as the standard language
set ffs=unix,dos,mac " Use Unix as the standard file type

"""""""""""""""""""""""
"  filetype settings  "
"""""""""""""""""""""""
" LaTeX
au BufRead,BufNewFile,FileType *.tex,*.tikz,*.sagetex
            \ set filetype=tex|
            \ set tw=100|
            \ set ts=2|
            \ set sw=2
" pandoc
au BufRead,BufNewFile,FileType vim,pandoc
            \ set tw=100|
            \ set ts=2|
            \ set sw=2
" python
au BufRead,BufNewFile *.sage set filetype=python
au BufRead,BufNewFile *.pxd,*.pyx,*.spyx
            \ set filetype=python |
            \ set syntax=pyrex
" html
au BufRead,BufRead *.mustache set filetype=html

au BufRead,BufNewFile,FileType gitcommit,mail,*.yaml,*.yml,*.md set tw=80

" code
exec "au BufRead,BufNewFile,FileType ".join(g:programming_fts, ',')." ".
            \ "set tw=120|"
            \ "set ts=4|"
            \ "set sw=4"
" others
au BufRead,BufNewFile ~/.mutt/* set filetype=muttrc

" syntaxed filetypes
exec "au BufRead,BufNewFile,Filetype ".join(g:syntaxed_fts, ',')." set si"

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Personal config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
source ~/.vim/functions.vim
source ~/.vim/mappings.vim

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugging config
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
source ~/.vim/plug-config/syntastic.vim
source ~/.vim/plug-config/ctrlp.vim
source ~/.vim/plug-config/vim-multi-cursor.vim
source ~/.vim/plug-config/utlisnips.vim

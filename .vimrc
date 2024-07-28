let mapleader = ','
syntax on
filetype plugin on
set number relativenumber
set ai
set tabstop=4
set ls=2
set shiftwidth=4
set expandtab
set nobackup
set incsearch
set smartcase
set showcmd
set showmode
set showmatch
set hlsearch
set wildmenu
set wildmode=list:longest
set mouse=
set ttymouse=
set virtualedit=onemore
set breakindent
set formatoptions=l
set lbr

highlight LineNr term=bold cterm=NONE ctermfg=DarkGrey ctermbg=NONE gui=NONE guifg=DarkGrey guibg=NONE


" PLUGINS ---------------------------------------------------------------- {{{
"Plug 'dense-analysis/ale'

call plug#begin('~/.vim/plugged')

  Plug 'preservim/nerdtree'
  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'PhilRunninger/nerdtree-visual-selection'

call plug#end()

" }}}


" MAPPINGS --------------------------------------------------------------- {{{

map <up> <C-w><up>
map <down> <C-w><down>
map <left> <C-w><left>
map <right> <C-w><right>
map <leader>n :bnext<cr>
map <leader>p :bprevious<cr>
map <leader>d :bdelete<cr>
map <leader>s :vertical ball<cr>
map <C-f> :NERDTreeToggle<cr>
map <C-/> :norm ^i//
map <C-x> :norm ^xx
    
nnoremap <leader>h :noh<CR>
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <c-u> <c-u>zz
nnoremap <c-d> <c-d>zz
nnoremap <c-j> :m .+1<CR>==
nnoremap <c-k> :m .-2<CR>==
inoremap <c-j> <Esc>:m .+1<CR>==gi
inoremap <c-k> <Esc>:m .-2<CR>==gi
vnoremap <c-j> :m '>+1<CR>gv=gv
vnoremap <c-k> :m '<-2<CR>gv=gv

nnoremap <leader>w :set nowrap
nnoremap k kzz
nnoremap j jzz

" }}}


" VIMSCRIPT -------------------------------------------------------------- {{{
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:ale_python_flake8_args="--ignore=E501"

" This will enable code folding.
augroup filetype_vim
    autocmd!
    autocmd FileType vim setlocal foldmethod=marker
augroup END

" Add vimspector
" :packadd! vimspector

" Open terminal at the bottom
:command T botright terminal

" Set the background tone.
set background=dark

" Set the color scheme.
colorscheme NorthernLights

" Hide the toolbar.
set guioptions-=T

" Hide the the left-side scroll bar.
set guioptions-=L

" Hide the the right-side scroll bar.
set guioptions-=r

" Hide the the menu bar.
set guioptions-=m

" Hide the the bottom scroll bar.
set guioptions-=b

" Map the F4 key to toggle the menu, toolbar, and scroll bar.
" <Bar> is the pipe character.
" <CR> is the enter key.
nnoremap <F4> :if &guioptions=~#'mTr'<Bar>
    \set guioptions-=mTr<Bar>
    \else<Bar>
    \set guioptions+=mTr<Bar>
    \endif<CR>

let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"

" }}}


" STATUS LINE ------------------------------------------------------------ {{{

" Clear status line when vimrc is reloaded.
set statusline=

" Status line left side.
set statusline+=\ %F\ %M\ %Y\ %R

" Use a divider to separate the left side from the right side.
set statusline+=%=

" Status line right side.
set statusline+=\ ascii:\ %b\ hex:\ 0x%B\ row:\ %l\ col:\ %c\ percent:\ %p%%

" Show the status on the second to last line.
set laststatus=2

" }}}

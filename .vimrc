let mapleader = ','
syntax on
filetype plugin on
set autochdir
set number relativenumber
set ai
set tabstop=2
set ls=2
set shiftwidth=2
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
" Pluging manager is https://github.com/junegunn/vim-plug "
call plug#begin('~/.vim/plugged')
  
  Plug 'preservim/nerdtree' 
  Plug 'prabirshrestha/vim-lsp'
  Plug 'mattn/vim-lsp-settings'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-lsp.vim'
  Plug 'PhilRunninger/nerdtree-visual-selection'
  Plug 'triglav/vim-visual-increment'
  Plug 'mbbill/undotree'
  Plug 'garbas/vim-snipmate'
  Plug 'marcweber/vim-addon-mw-utils'
  Plug 'tomtom/tlib_vim'
  Plug 'honza/vim-snippets'
  Plug 'unkiwii/vim-nerdtree-sync'
  Plug 'doums/darcula'
  Plug 'vim-scripts/vim-auto-save'

call plug#end()

" }}}


"  MAPPINGS --------------------------------------------------------------- {{{

noremap <up> <C-w><up>
noremap <down> <C-w><down>
noremap <left> <C-w><left>
noremap <right> <C-w><right>
noremap <leader>n :bnext<cr>
noremap <leader>d :bdelete<cr>
noremap <leader>m :bprevious<cr>
noremap <leader>s :vertical ball<cr>
noremap <C-/> :norm ^i//
noremap <C-x> :norm ^xx
noremap <C-q> :q<CR>
noremap <C-s> :w<CR>
noremap <C-;> :%y*<CR>
noremap <C-n> :%s///g<Left><Left><Left>
noremap <C-y> :-y<Left>
noremap <C-h> :LspHover<CR>

inoremap <c-j> <Esc>:m .+1<CR>==gi
inoremap <c-k> <Esc>:m .-2<CR>==gi
inoremap { {}<Esc>ha
inoremap ( ()<Esc>ha
inoremap [ []<Esc>ha
inoremap " ""<Esc>ha
inoremap ' ''<Esc>ha
inoremap ` ``<Esc>ha

vnoremap <c-j> :m '>+1<CR>gv=gv
vnoremap <c-k> :m '<-2<CR>gv=gv
vnoremap <C-x> :norm ^xx

nnoremap <leader>h :noh<CR>
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap <c-u> <c-u>zz
nnoremap <c-d> <c-d>zz
nnoremap <c-j> :m .+1<CR>==
nnoremap <c-k> :m .-2<CR>==
nnoremap <c-c> ggdG
nnoremap <leader>w :set nowrap
nnoremap k kzz
nnoremap j jzz
nnoremap <leader>f va{Voky<CR>
nnoremap <leader>t :UndotreeToggle<CR>
nnoremap <leader>s :!
nnoremap Y y$
nnoremap { {zz
nnoremap } }zz

imap <tab> <Plug>snipMateNextOrTrigger
smap <tab> <Plug>snipMateNextOrTrigger


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

let &t_SI = "\e[6 q" 
let &t_EI = "\e[2 q"
let g:nerdtree_sync_cursorline = 1
let g:auto_save = 1

" Open NERDTree in the directory of the current file (or /home if no file is open)
nmap <silent> <C-f> :call NERDTreeToggleInCurDir()<cr>
function! NERDTreeToggleInCurDir()
  " If NERDTree is open in the current buffer
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    exe ":NERDTreeClose"
  else
    exe ":NERDTreeFind"
  endif
endfunction

command FORMAT :LspDocumentFormat
command FIND :LspReferences  
command RENAME :LspRename  
command DEF :LspDefinition                  

" Toggling diagnostics and virtual text {{{
autocmd BufEnter * let b:my_lsp_diagnostics_enabled = 1
function! s:MyToggleLSPDiagnostics()
	" source: https://github.com/prabirshrestha/vim-lsp/issues/1312
    if !exists('b:my_lsp_diagnostics_enabled')
		" Ensure the buffer variable is defined
        let b:my_lsp_diagnostics_enabled = 1
    endif
    if b:my_lsp_diagnostics_enabled == 1
        call lsp#disable_diagnostics_for_buffer()
        let b:my_lsp_diagnostics_enabled = 0
        echo "LSP Diagnostics : OFF"
    else
        call lsp#enable_diagnostics_for_buffer()
        let b:my_lsp_diagnostics_enabled = 1
        echo "LSP Diagnostics : ON"
    endif
endfunction
command MyToggleLSPDiagnostics call s:MyToggleLSPDiagnostics()
nnoremap <leader><leader> :MyToggleLSPDiagnostics<CR>zz


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

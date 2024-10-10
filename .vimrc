" Basic settings for better editing experience {{{

" Set leader key early for easy mapping
let mapleader = ','
syntax on
filetype plugin indent on  " Enable filetype detection, plugins, and indent

" Performance and UI enhancements
set number relativenumber  " Show line numbers and relative numbers
set tabstop=2 shiftwidth=2 expandtab  " Use spaces instead of tabs
set autoindent  " Automatically indent new lines
set ls=2  " Always show status line
set showcmd  " Show command in the last line of the screen
set wildmenu wildmode=list:longest  " Enhanced command-line completion
set incsearch hlsearch smartcase  " Improved searching
set nobackup noswapfile  " No backup or swap files
set virtualedit=onemore  " Allow cursor to move one character past the end of the line
set lazyredraw  " Redraw screen only when necessary
set backspace=indent,eol,start
set scrolloff=8  " Keep 8 lines visible above and below the cursor
set nowrap
set ttyfast
" set termguicolors

" Kitty setting
" Mouse support
set mouse=a
set ttymouse=sgr
set balloonevalterm
" Styled and colored underline support
let &t_AU = "\e[58:5:%dm"
let &t_8u = "\e[58:2:%lu:%lu:%lum"
let &t_Us = "\e[4:2m"
let &t_Cs = "\e[4:3m"
let &t_ds = "\e[4:4m"
let &t_Ds = "\e[4:5m"
let &t_Ce = "\e[4:0m"
" Strikethrough
let &t_Ts = "\e[9m"
let &t_Te = "\e[29m"
" Truecolor support
let &t_8f = "\e[38:2:%lu:%lu:%lum"
let &t_8b = "\e[48:2:%lu:%lu:%lum"
let &t_RF = "\e]10;?\e\\"
let &t_RB = "\e]11;?\e\\"
" Bracketed paste
let &t_BE = "\e[?2004h"
let &t_BD = "\e[?2004l"
let &t_PS = "\e[200~"
let &t_PE = "\e[201~"
" Cursor control
let &t_RC = "\e[?12$p"
let &t_SH = "\e[%d q"
let &t_RS = "\eP$q q\e\\"
let &t_SI = "\e[5 q"
let &t_SR = "\e[3 q"
let &t_EI = "\e[1 q"
let &t_VS = "\e[?12l"
" Focus tracking
let &t_fe = "\e[?1004h"
let &t_fd = "\e[?1004l"
execute "set <FocusGained>=\<Esc>[I"
execute "set <FocusLost>=\<Esc>[O"
" Window title
let &t_ST = "\e[22;2t"
let &t_RT = "\e[23;2t"

" vim hardcodes background color erase even if the terminfo file does
" not contain bce. This causes incorrect background rendering when
" using a color theme with a background color in terminals such as
" kitty that do not support background color erase.
let &t_ut=''

" }}}

" Plugins settings {{{
let g:lsp_fold_enabled = 0
let g:lsp_diagnostics_echo_cursor = 1
let g:lsp_inlay_hints_enabled = 0
let g:lsp_diagnostics_virtual_text_enabled = 0
let g:lsp_diagnostics_virtual_text_align = "right"
let g:lsp_diagnostics_virtual_text_delay = 10
let g:lsp_diagnostics_highlights_enabled = 0

" }}}

" Colorscheme settings {{{
colorscheme habamax " Choose a minimal colorscheme
highlight Normal ctermfg=None ctermbg=None
" }}}

" Folding settings {{{
set foldmethod=marker  " Use 'marker' for folding based on markers ({{{ and }}})
set foldlevel=0        " Start with all folds closed
set foldenable         " Enable folding
" }}}

" PLUGINS {{{
call plug#begin('~/.vim/plugged')
Plug 'preservim/nerdtree'
Plug 'PhilRunninger/nerdtree-visual-selection'
Plug 'prabirshrestha/vim-lsp'
Plug 'mattn/vim-lsp-settings'
Plug 'prabirshrestha/asyncomplete.vim'
Plug 'prabirshrestha/asyncomplete-lsp.vim'
Plug 'garbas/vim-snipmate'
Plug 'honza/vim-snippets'
Plug 'yggdroot/indentline'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
call plug#end()
" }}}

" MAPPINGS {{{
" Essential mappings for better navigation and editing
noremap ; :
noremap <leader>h :noh<CR>  " Clear search highlighting
noremap <leader>q :q<CR>  " Quick quit
noremap <leader>w :w<CR>  " Quick save

" Copy and paste using system clipboard
noremap <leader>y "+y  " Copy to system clipboard
noremap <leader>Y "+Y  " Copy line to system clipboard
noremap <leader>p "+p  " Paste from system clipboard
noremap <leader>P "+P  " Paste before cursor from system clipboard

" Navigating splits with arrow keys
noremap <up> <c-w>k
noremap <down> <c-w>j
noremap <left> <c-w>h
noremap <right> <c-w>l

" Move line up and down
nnoremap <c-j> :m .+1<CR>==
nnoremap <c-k> :m .-2<CR>==

" Move selected lines up and down
vnoremap <c-j> :m '>+1<CR>gv=gv
vnoremap <c-k> :m '<-2<CR>gv=gv

" Indent selected lines left and right
vnoremap < <gv
vnoremap > >gv

" Center the cursor 
nnoremap G Gzz 
nnoremap gg ggzz
nnoremap <c-d> <C-d>zz
nnoremap <c-u> <C-u>zz
nnoremap j jzz
nnoremap k kzz
nnoremap n nzzzv
nnoremap N Nzzzv
nnoremap * *zz
nnoremap # #zz
nnoremap } }zz
nnoremap { {zz

" Easier indenting in visual mode
vnoremap < <gv
vnoremap > >gv

" NERDTree toggle
nnoremap <silent> <c-f> :NERDTreeToggleInCurDir<CR>

" SnipMate mappings for snippets
imap <tab> <Plug>snipMateNextOrTrigger
smap <tab> <Plug>snipMateNextOrTrigger

" Folding commands
nnoremap <leader>o za  " Toggle fold
nnoremap <leader>O zM  " Close all folds
nnoremap <leader>c zR  " Open all folds

" Open and close quickfix list
nnoremap <leader>co :copen<CR>
nnoremap <leader>cc :cclose<CR>

" Navigate quickfix list
nnoremap <leader>cn :cnext<CR>
nnoremap <leader>cp :cprevious<CR>
nnoremap <c-o> <c-o>zz

" fzf mappings
nnoremap <leader>bu :w<CR>:Buffers<CR>
nnoremap <leader>fi :w<CR>:Files<CR>
nnoremap <leader>fr :w<CR>:Files ~<CR>
nnoremap <leader>cl :w<CR>:Colors<CR>
nnoremap <leader>ag :w<CR>:Ag<CR> 
nnoremap <leader>rg :w<CR>:Rg<CR>
nnoremap <leader>fs :w<CR>:GFiles?<CR>
nnoremap <leader>bl :w<CR>:BLines<CR> 
nnoremap <leader>ma :w<CR>:Maps<CR>

" Toggle line numbers mode
nnoremap <leader>n :set relativenumber!<CR>

" Map the toggle function to a key combination, e.g., <F5>
nnoremap <leader>cd :call ToggleAutoChdir()<CR>
" }}}

" LSP SHORTCUTS {{{
" LSP-related shortcuts for better code navigation and manipulation
nnoremap <silent><leader>gd :LspDefinition<CR>        " Go to definition
nnoremap <silent><leader>gr :LspReferences<CR>        " Find references
nnoremap <silent><leader>gi :LspImplementation<CR>    " Go to implementation
nnoremap <silent><leader>gt :LspTypeDefinition<CR>    " Go to type definition
nnoremap <silent><leader>rn :LspRename<CR>            " Rename symbol
nnoremap <silent><leader>ca :LspCodeAction<CR>        " Show code actions
nnoremap <silent><leader>df :LspDocumentFormat<CR>    " Format the document
nnoremap <silent><leader>dj :LspNextDiagnostic<CR>    " Go to next diagnostic
nnoremap <silent><leader>dk :LspPreviousDiagnostic<CR> " Go to previous diagnostic
nnoremap <silent><leader>dh :LspHover<CR>             " Show hover information
nnoremap <silent><leader>ds :LspSignatureHelp<CR>     " Show signature help
nnoremap <silent><leader>dp :LspPeekDefinition<CR>    " Peek definition (if supported)
nnoremap <silent><leader><leader> :MyToggleLSPDiagnostics<CR>
" }}}

" VIMSCRIPT {{{
" NERDTree: Open in the directory of the current file
function! s:NERDTreeToggleInCurDir()
  if (exists("t:NERDTreeBufName") && bufwinnr(t:NERDTreeBufName) != -1)
    exe ":NERDTreeClose"
  else
    exe ":NERDTreeFind"
  endif
endfunction
command! NERDTreeToggleInCurDir call s:NERDTreeToggleInCurDir()

" Toggling diagnostics and virtual text
function! s:MyToggleLSPDiagnostics()
    if !exists('b:my_lsp_diagnostics_enabled')
        let b:my_lsp_diagnostics_enabled = 1
    endif
    if b:my_lsp_diagnostics_enabled == 1
        call lsp#disable_diagnostics_for_buffer()
        let b:my_lsp_diagnostics_enabled = 0
        echo "LSP Diagnostics: OFF"
    else
        call lsp#enable_diagnostics_for_buffer()
        let b:my_lsp_diagnostics_enabled = 1
        echo "LSP Diagnostics: ON"
    endif
endfunction
command! MyToggleLSPDiagnostics call s:MyToggleLSPDiagnostics()

function! TwiddleCase(str)
  if a:str ==# toupper(a:str)
    let result = tolower(a:str)
  elseif a:str ==# tolower(a:str)
    let result = substitute(a:str,'\(\<\w\+\>\)', '\u\1', 'g')
  else
    let result = toupper(a:str)
  endif
  return result
endfunction
vnoremap ~ y:call setreg('', TwiddleCase(@"), getregtype(''))<CR>gv""Pgv

function! ToggleAutoChdir()
    if &autochdir
        set noautochdir
        echo "Autochdir OFF"
    else
        set autochdir
        echo "Autochdir ON"
    endif
endfunction
" }}}

" STATUS LINE {{{
" Minimal status line for performance
set statusline=%{getcwd()}\ %f\ %y\ %r\ %m\ %=%l:%c
set laststatus=2
" }}}

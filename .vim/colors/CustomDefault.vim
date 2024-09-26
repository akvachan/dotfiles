" Custom Default Theme for Vim

if version < 700
  finish
endif

set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "custom_default"

" Use the default background by not setting guibg
hi Normal       guifg=#FFFFFF

" Modify specific syntax elements
hi Comment      guifg=#5F5A60 gui=italic
hi Constant     guifg=#D19A66
hi Identifier   guifg=#61AFEF
hi Statement    guifg=#C678DD
hi PreProc      guifg=#E5C07B
hi Type         guifg=#56B6C2
hi Special      guifg=#98C379
hi Underlined   guifg=#56B6C2 gui=underline

" Leave other elements as default (unmodified)
hi CursorLine   guibg=NONE
hi LineNr       guifg=#5F5A60 guibg=NONE
hi StatusLine   guifg=#C8CCD4 guibg=NONE
hi StatusLineNC guifg=#5F5A60 guibg=NONE
hi Pmenu        guifg=#D8DEE9 guibg=#3B4048
hi PmenuSel     guifg=#FFFFFF guibg=#61AFEF
hi Visual       guibg=#4B5363

" LSP Diagnostics (optional)
hi LspDiagnosticsDefaultError guifg=#E06C75
hi LspDiagnosticsDefaultWarning guifg=#E5C07B
hi LspDiagnosticsDefaultInformation guifg=#61AFEF
hi LspDiagnosticsDefaultHint guifg=#56B6C2

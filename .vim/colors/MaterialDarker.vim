" Material Darker Theme for Vim
" Inspired by the Material Darker color scheme

if version < 700
  finish
endif

set background=dark
hi clear

if exists("syntax_on")
  syntax reset
endif

let g:colors_name = "material_darker"

" Define the color palette
hi Normal       guifg=#B0BEC5 guibg=#212121
hi CursorLine   guibg=#263238
hi CursorColumn guibg=#263238
hi LineNr       guifg=#546E7A guibg=NONE
hi Comment      guifg=#546E7A gui=italic
hi Constant     guifg=#C3E88D
hi String       guifg=#C3E88D
hi Identifier   guifg=#F07178
hi Statement    guifg=#82AAFF
hi PreProc      guifg=#FFCB6B
hi Type         guifg=#C792EA
hi Special      guifg=#89DDFF
hi Underlined   guifg=#82AAFF gui=underline
hi Todo         guifg=#FF5370 guibg=#3E4451
hi Search       guifg=#000000 guibg=#FFCB6B
hi Visual       guibg=#3E4451
hi StatusLine   guifg=#B0BEC5 guibg=#424242
hi StatusLineNC guifg=#546E7A guibg=#263238
hi Pmenu        guibg=#2E2E2E guifg=#B0BEC5
hi PmenuSel     guibg=#424242 guifg=#EEFFFF
hi VertSplit    guifg=#263238

" Define more specific syntax highlighting
hi Function     guifg=#82AAFF
hi Operator     guifg=#89DDFF
hi Keyword      guifg=#C792EA
hi Number       guifg=#F78C6C
hi Boolean      guifg=#F78C6C
hi Conditional  guifg=#C792EA
hi Repeat       guifg=#C792EA

" LSP Diagnostics
hi LspDiagnosticsDefaultError guifg=#F07178
hi LspDiagnosticsDefaultWarning guifg=#FFCB6B
hi LspDiagnosticsDefaultInformation guifg=#82AAFF
hi LspDiagnosticsDefaultHint guifg=#C3E88D

" Diff highlighting
hi DiffAdd      guibg=#2E7D32
hi DiffChange   guibg=#455A64
hi DiffDelete   guibg=#D32F2F
hi DiffText     guibg=#1976D2

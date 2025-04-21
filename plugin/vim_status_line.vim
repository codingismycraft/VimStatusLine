"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"
"                               John Pazarzis
"
" Simple status line pluggin for vim focusing on git integration.
"
" This is a straightforward Vim plugin designed to integrate with Git. The
" focus is on simplicity, deliberately avoiding the use of complex plugins.
" This approach allows for easy customization and maintenance. Additionally,
" the status line does not include fancy emojis or images, as the main
" objective is to keep it clean and minimalistic."
"
"        ,---,---,---,---,---,---,---,---,---,---,---,---,---,-------,
"        |---'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-----|
"        | ->| | Q | W | E | R | T | Y | U | I | O | P | ] | ^ |     |
"        |-----',--',--',--',--',--',--',--',--',--',--',--',--'|    |
"        | Caps | A | S | D | F | G | H | J | K | L | \ | [ | * |    |
"        |----,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'-,-'---'----|
"        |    | < | Z | X | C | V | B | N | M | , | . | - |          |
"        |----'-,-',--'--,'---'---'---'---'---'---'-,-'---',--,------|
"        | ctrl |  | alt |                          |altgr |  | ctrl |
"        '------'  '-----'--------------------------'------'  '------'
"
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

 " As a reference the following is the list of cterm-colors:
 "
 " NR-16   NR-8    COLOR NAME
 " 0       0       Black
 " 1       4       DarkBlue
 " 2       2       DarkGreen
 " 3       6       DarkCyan
 " 4       1       DarkRed
 " 5       5       DarkMagenta
 " 6       3       Brown, DarkYellow
 " 7       7       LightGray, LightGrey, Gray, Grey
 " 8       0*      DarkGray, DarkGrey
 " 9       4*      Blue, LightBlue
 " 10      2*      Green, LightGreen
 " 11      6*      Cyan, LightCyan
 " 12      1*      Red, LightRed
 " 13      5*      Magenta, LightMagenta
 " 14      3*      Yellow, LightYellow
 " 15      7*      White

" Map to mode name.  "

let g:currentmode={
    \ 'n'  : 'NORMAL',
    \ 'v'  : 'VISUAL',
    \ 'V'  : 'V·LINE',
    \ '' : 'V·BLOCK',
    \ 's'  : 'SELECT',
    \ 'S'  : 'S·LINE',
    \ '' : 'S·BLOCK',
    \ 'i'  : 'INSERT',
    \ 'R'  : 'REPLACE',
    \ 'Rv' : 'V·REPLACE',
    \ 'c'  : 'COMMAND',
    \ 't'  : 'TERMINAL',
    \}


" Customize colors based on the color scheme used.
"
if exists('g:colors_name')
    if g:colors_name==# 'zenburn'
        let g:status_back_color = 'green'
        highlight! Visual cterm=NONE ctermbg=0 ctermfg=NONE guibg=Grey10
    elseif g:colors_name==# 'glacier'
        let g:status_back_color = '21'
        highlight! Visual cterm=NONE ctermbg=White ctermfg=Black guibg=Black
    endif
endif

" Colors for file names based on their git status.
hi! FileModified ctermfg=17   ctermbg=cyan
hi! FileStaged ctermfg=black ctermbg=green
hi! FileUntracked ctermfg=white ctermbg=52
hi! FileCommited ctermfg=white ctermbg=blue
hi! FileNotAvailable ctermfg=242
hi! InsertMode ctermfg=black ctermbg=red
hi! ColumnNumber ctermfg=black ctermbg=gray

if exists('g:colors_name')
    if g:colors_name ==# 'zenburn' || g:colors_name ==# 'glacier'
        execute 'hi! StatusLine   cterm=bold ctermbg='.g:status_back_color.' guibg=blue guifg=cyan'
        execute 'hi! StatusLineNC cterm=bold ctermbg='.g:status_back_color.' guibg=black guifg=Gray'
    endif
endif

let separator = '  '

" Build the status line.
set statusline=


" Add the mode.
set statusline+=%F
set statusline+=%#InsertMode#%10{(currentmode[mode()]=='INSERT')?'INSERT':''}
set statusline+=%#StatusLine#%10{(currentmode[mode()]!='INSERT')?currentmode[mode()]:''}

" Mark buffer with unsaved chaneges.
set statusline+=%3*%-3m%* " [+] if the buffer has unsaved changes.

" Add the column number.
set statusline+=%#StatusLine#
set statusline+=%3{separator}
set statusline+=%#ColumnNumber#%4.4c " Current column number
set statusline+=%#ColumnNumber#
set statusline+=%3{separator}

" Add the branch name.
set statusline+=%#StatusLine#


" Fix the missing colorschemes when loading a session..
"
" I have found out that when saving / loading a session then
" the colors are lost so, this is hack is meant to fix it..
"
" See also https://stackoverflow.com/questions/12797928/vim-statusline-loses-colors-after-reopening-session

autocmd ColorScheme * hi FileModified ctermfg=17   ctermbg=cyan
autocmd ColorScheme * hi FileStaged ctermfg=black ctermbg=green
autocmd ColorScheme * hi FileUntracked ctermfg=white ctermbg=52
autocmd ColorScheme * hi FileCommited ctermfg=white ctermbg=blue
autocmd ColorScheme * hi FileNotAvailable ctermfg=242
autocmd ColorScheme * hi InsertMode ctermfg=black ctermbg=red
autocmd ColorScheme * hi ColumnNumber ctermfg=black ctermbg=gray

if exists('g:colors_name')
    if g:colors_name ==# 'zenburn' || g:colors_name ==# 'glacier'
        execute 'autocmd ColorScheme * hi StatusLine cterm=bold ctermbg='.g:status_back_color.' guibg=blue guifg=cyan'
        execute 'autocmd ColorScheme * hi StatusLineNC cterm=bold ctermbg='.g:status_back_color.'  guibg=black guifg=Gray'
    endif
endif




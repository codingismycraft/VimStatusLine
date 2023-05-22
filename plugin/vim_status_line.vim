" Pretty simple status line, purposely I am dodging the use of fancy plugins.
" Map to mode name.
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
    \}


" Colors for file names based on their git status.
hi! FileModified ctermfg=17   ctermbg=cyan   
hi! FileStaged ctermfg=black ctermbg=green
hi! FileUntracked ctermfg=white ctermbg=52    
hi! FileCommited ctermfg=white ctermbg=blue
hi! FileNotAvailable ctermfg=242 
hi! InsertMode ctermfg=black ctermbg=red
hi! ColumnNumber ctermfg=black ctermbg=gray
hi! StatusLine cterm=bold ctermbg=21 guibg=blue guifg=cyan
hi! StatusLineNC cterm=bold ctermbg=21 guibg=black guifg=Gray

let separator = '  '

" Build the status line.
set statusline=

" Add the file name.
set statusline+=%#FileModified#%-20.20{(vim_status_line#GetGitFileStatus()=='modified')?vim_status_line#GetActiveFilename():''}
set statusline+=%#FileStaged#%-20.20{(vim_status_line#GetGitFileStatus()=='staged')?vim_status_line#GetActiveFilename():''}
set statusline+=%#FileUntracked#%-20.20{(vim_status_line#GetGitFileStatus()=='untracked')?vim_status_line#GetActiveFilename():''}
set statusline+=%#StatusLine#%-20.20{(vim_status_line#GetGitFileStatus()=='commited')?vim_status_line#GetActiveFilename():''}
set statusline+=%#StatusLine#%-20.20{(vim_status_line#GetGitFileStatus()=='n/a')?vim_status_line#GetActiveFilename():''}

" Add the mode.
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
set statusline+=%28{vim_status_line#GetGitBranch()}

" Timer to rerfesh the status line.
call timer_start(7000, {-> execute(':let &stl=&stl')}, {'repeat': -1})


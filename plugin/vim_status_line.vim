" Pretty simple status line, purposely I am dodging the use of fancy plugins.

set statusline=
set statusline+=%-20t  " File name (tail) of file in the buffer.
set statusline+=%-3n   " The buffer number.
set statusline+=%3*%-3m%* " [+] if the buffer has unsaved changes.
set statusline+=%-10{g:currentmode[mode()]} " The current mode.
set statusline+=%4c " Current column


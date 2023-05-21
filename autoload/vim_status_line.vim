let s:plugin_path = expand('<sfile>:p:h')
let s:path_was_added = 0


python3 << endpython

import os
import sys
import vim


def preparePythonPath():
    """Adds the path of the related code to the python path.

    The path is added only once since we rely on a script scoped
    variable (path_was_added) as the import guard.
    """
    was_added = int(vim.eval("s:path_was_added"))
    if not was_added:
        path = vim.eval("s:plugin_path")
        path = os.path.dirname(path)
        sys.path.insert(0, path)
        vim.command("let s:path_was_added = 1")

endpython


function! vim_status_line#GetGitFileStatus()
" Returns the git status for the active file, called from the status line.
" Possible values: modified, staged, untracked, commited, n/a
let git_info = "n/a" 
python3 << endpython
preparePythonPath()
import vim_status_line.vim_status_line as vsl
home_dir = vim.eval("""expand("$HOME")""")
fullpath = vim.eval("""expand("%:p")""").strip()
filepath = os.path.join(home_dir, fullpath)
git_status = vsl.getFileStatus(filepath, vsl.makeTimeHash())
git_info = f'{git_status}'
vim.command(f"let git_info='{git_info}'")
endpython
return git_info
endfunction

function! vim_status_line#GetGitBranch()
" Returns the git branch for the active file.
" Possible values: <branch-name>, n/a
let git_branch = "n/a" 
python3 << endpython
preparePythonPath()
import vim_status_line.vim_status_line as vsl
import os
home_dir = vim.eval("""expand("$HOME")""")
fullpath = vim.eval("""expand("%:p")""").strip()
if len(fullpath) == 0:
    # No file selected, use current dir.
    filepath = os.getcwd()
else:
    filepath = os.path.join(home_dir, fullpath).strip()
git_branch = vsl.getBranchName(filepath, vsl.makeTimeHash())
git_branch = f'{git_branch}'
vim.command(f"let git_branch='{git_branch}'")
endpython
return git_branch
endfunction

function! vim_status_line#GetActiveFilename()
" Returns the active filename.
let filepath = "n/a" 
python3 << endpython
filepath  = vim.eval("""expand("%:p")""").strip()
filepath = os.path.basename(filepath)
if not filepath:
    filepath = 'n/a'
vim.command(f"let filepath='{filepath}'")
endpython
return filepath
endfunction

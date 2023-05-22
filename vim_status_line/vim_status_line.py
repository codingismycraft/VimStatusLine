"""Exposes functionality to collect git status."""


from subprocess import call, STDOUT
import subprocess
import os
import functools
import time


# The default time in seconds to use for hashing.
_DEFAULT_HASH_TIME = 2


def _findGitRoot(path):
    """Finds the root of the git repo for the passed in file path.

    (str) path: The full path to the file to lookup.

    Returns the root directory for the git repo that contains the file.
    Raises FileNotFoundError:  The file does not belong to a git repo.
    """
    if os.path.isfile(path):
        path = os.path.dirname(path)
    for name in os.listdir(path):
        if name == '.git' and os.path.isdir(os.path.join(path, name)):
            return path
    parent_dir = os.path.dirname(path)
    if not parent_dir or parent_dir == '/':
        raise FileNotFoundError
    else:
        return _findGitRoot(parent_dir)


def makeTimeHash(seconds=_DEFAULT_HASH_TIME):
    """Makes a time hash based on the passed in seconds."""
    return round(time.time() / seconds)


@functools.lru_cache()
def getFileStatus(filepath, time_hash=None):
    """Returns the git status for the passed in file.

    git status -s <filename>
    """
    if not os.path.isfile(filepath):
        return "n/a"
    try:
        root_dir = _findGitRoot(filepath)
    except FileNotFoundError:
        return "n/a"
    else:
        current_dir = os.getcwd()
        os.chdir(root_dir)
        status = subprocess.check_output(["git", "status", "-s", filepath])
        status = status.decode()
        if status.startswith("M"):
            status = "staged"
        elif status.startswith(" M"):
            status = "modified"
        elif status.startswith("??"):
            status = "untracked"
        elif status.strip() == '':
            status = "commited"
        else:
            status = "n/a"
        os.chdir(current_dir)
        return status


@functools.lru_cache()
def getBranchName(filepath, time_hash=None):
    """Returns the branch name for the passed in file.

    git branch --show-current
    """
    try:
        root_dir = _findGitRoot(filepath)
    except FileNotFoundError:
        return "n/a"
    else:
        current_dir = os.getcwd()
        os.chdir(root_dir)
        branch_name = subprocess.check_output(
            ["git", "branch", "--show-current"]
        )
        branch_name = branch_name.decode().strip()
        os.chdir(current_dir)
        return branch_name

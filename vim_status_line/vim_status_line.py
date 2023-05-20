"""Exposes functionality to collect git status."""


from subprocess import call, STDOUT
import subprocess
import os


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


def collectGitStatus(filepath):
    """Returns git information about the git repo of the passed in file.

    (str) filepath: The full path to the file to use.

    If the file does not belong to a git repo returns None otherwise
    it will return a dictionary describing the related git info.
    """
    try:
        root_dir = _findGitRoot(filepath)
    except FileNotFoundError:
        return None
    else:
        current_path = os.getcwd()
        os.chdir(root_dir)
        branch = subprocess.check_output(["git", "branch", "--show-current"])
        branch = branch.decode().strip()
        changes = subprocess.check_output(["git", "status", "-s"])
        lines = changes.decode().split('\n')
        modified = []
        added = []
        untracked = []
        for line in lines:
            line = line.rstrip()
            if not line.strip():
                continue
            if line.startswith("M"):
                added.append(os.path.join(root_dir, line[1:].strip()))
            elif line.startswith(" M"):
                modified.append(os.path.join(root_dir, line[2:].strip()))
            elif line.startswith("??"):
                untracked.append(os.path.join(root_dir, line[2:].strip()))
            else:
                pass
        os.chdir(current_path)
        return {
            "branch": branch,
            "modified": modified,
            "added": added,
            "untracked": untracked
        }


def getFileStatus(filepath):
    """Returns the git info for the passed in file."""
    gs = collectGitStatus(filepath)
    if not gs:
        return ""
    branch = gs.get("branch", "n/a")
    if filepath in gs["modified"]:
        return "modified", branch
    elif filepath in gs["added"]:
        return "added", branch
    elif filepath in gs["untracked"]:
        return "untracked", branch
    else:
        return "unknown", branch

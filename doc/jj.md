# jj (Jujutsu) - Modern Version Control

A Git-compatible VCS with a simpler mental model. Works on existing Git repos.

https://docs.jj-vcs.dev/latest/

## Install

```bash
# Arch
paru -S jj

# Or cargo
cargo install jj-cli
```

## Key Differences from Git

| | Git | jj |
|---|-----|-----|
| Working copy | Separate from commits | Is a commit (auto-tracked) |
| Staging | `git add` to stage | No staging - changes auto-included |
| Conflicts | Must resolve before commit | Can commit conflicts, resolve later |
| Branches | Required, named refs | Anonymous by default |
| Undo | `git reflog` + manual | `jj undo` for everything |
| Backend | Git only | Uses your existing .git folder |

## Workflow Comparison

### Git
```bash
# Edit files...
git status
git add file1 file2
git commit -m "message"
git push
```

### jj
```bash
# Edit files...
jj status                     # Changes already tracked
jj describe -m "message"      # Set commit message
jj new                        # Start fresh working commit
jj git push                   # Push to remote
```

## Common Commands

| Git | jj | Description |
|-----|-----|-------------|
| `git status` | `jj status` / `jj st` | Show changes |
| `git diff` | `jj diff` | Show diff |
| `git log` | `jj log` | Show history |
| `git add + commit` | `jj describe -m "msg"` | Commit changes |
| `git commit --amend` | `jj describe -m "msg"` | Same command! |
| `git checkout -b` | `jj new` | Start new change |
| `git push` | `jj git push` | Push to remote |
| `git pull` | `jj git fetch` | Fetch from remote |
| - | `jj undo` | Undo any operation |
| `git rebase -i` | `jj squash` / `jj split` | Rewrite history |

## Why jj?

1. **No staging area** - All changes automatically included
2. **Everything is mutable** - Easy to rewrite any commit
3. **First-class undo** - `jj undo` works for everything
4. **Conflicts as commits** - Commit now, resolve later
5. **Anonymous branches** - Less branch management overhead
6. **Git compatible** - Works with GitHub, uses existing .git

## When to Use

**jj shines for:**
- Frequent history rewrites
- Complex rebases
- Feature branch workflows
- "Oops" recovery

**Git is fine for:**
- Simple linear workflows
- Small repos like dotfiles
- Team familiarity matters

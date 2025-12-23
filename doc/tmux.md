# tmux Cheat Sheet

**Prefix: `Ctrl-a`**

## Sessions

| Key | Action |
|-----|--------|
| `prefix + d` | Detach |
| `prefix + s` | List sessions (x to kill, y to confirm) |
| `prefix + $` | Rename session |

## Windows (tabs)

| Key | Action |
|-----|--------|
| `prefix + c` | New window |
| `prefix + n/p` | Next/prev window |
| `prefix + 0-9` | Go to window # |
| `prefix + ,` | Rename window |
| `prefix + &` | Kill window |

## Panes

| Key | Action |
|-----|--------|
| `prefix + \` | Split horizontal |
| `prefix + -` | Split vertical |
| `prefix + h/j/k/l` | Navigate panes (vim-style) |
| `prefix + x` | Kill pane |
| `prefix + z` | Toggle pane zoom (fullscreen) |
| `prefix + {` / `}` | Swap pane left/right |
| `prefix + space` | Cycle layouts |

## Other

| Key | Action |
|-----|--------|
| `prefix + r` | Reload config |
| `prefix + [` | Enter copy mode (scroll/search) |
| `q` | Exit copy mode |

## Custom Scripts

### tmux-dev

Start a dev layout with nvim, claude, and a shell:

```bash
tmux-dev          # starts "dev" session
tmux-dev myproj   # starts "myproj" session
```

Layout:
```
┌────────────┬─────────────────┐
│            │ claude --continue│
│   nvim .   ├─────────────────┤
│            │      zsh        │
└────────────┴─────────────────┘
    60%            40%
```

## CLI Commands

```bash
tmux                      # Start new session
tmux new -s name          # Start named session
tmux attach -t name       # Attach to session
tmux kill-session -t name # Kill session
tmux ls                   # List sessions
```

# Neovim (AstroNvim) Cheat Sheet

**Leader key: `Space`**

## File Navigation

| Key | Action |
|-----|--------|
| `leader + e` | Toggle file explorer (neo-tree) |
| `leader + o` | Focus file explorer |
| `leader + ff` | Find files |
| `leader + fw` | Find word (grep) |
| `leader + fb` | Find buffers |
| `leader + fr` | Recent files |

## Buffers

| Key | Action |
|-----|--------|
| `leader + c` | Close buffer |
| `leader + C` | Force close buffer |
| `leader + bb` | Switch buffer (picker) |
| `]b` / `[b` | Next/prev buffer |
| `>b` / `<b` | Move buffer right/left |

## Windows/Splits

| Key | Action |
|-----|--------|
| `\` | Horizontal split |
| `\|` | Vertical split |
| `Ctrl + h/j/k/l` | Navigate windows |
| `Ctrl + arrows` | Resize windows |
| `leader + q` | Close window |

## LSP (Code Intelligence)

| Key | Action |
|-----|--------|
| `gd` | Go to definition |
| `gD` | Go to declaration |
| `gr` | Go to references |
| `gI` | Go to implementation |
| `gy` | Go to type definition |
| `K` | Hover documentation |
| `leader + la` | Code actions |
| `leader + lr` | Rename symbol |
| `leader + lf` | Format buffer |
| `leader + ld` | Line diagnostics |
| `]d` / `[d` | Next/prev diagnostic |

## Git

| Key | Action |
|-----|--------|
| `leader + gg` | Lazygit |
| `leader + gb` | Git blame line |
| `leader + gd` | Git diff |
| `]g` / `[g` | Next/prev git hunk |
| `leader + gs` | Stage hunk |
| `leader + gr` | Reset hunk |

## Search & Replace

| Key | Action |
|-----|--------|
| `/` | Search forward |
| `?` | Search backward |
| `n` / `N` | Next/prev match |
| `*` / `#` | Search word under cursor |
| `:%s/old/new/g` | Replace all in file |
| `:%s/old/new/gc` | Replace with confirm |

## Editing

| Key | Action |
|-----|--------|
| `gcc` | Toggle line comment |
| `gc` (visual) | Toggle comment selection |
| `leader + /` | Toggle comment |
| `u` / `Ctrl + r` | Undo/redo |
| `.` | Repeat last change |
| `>>` / `<<` | Indent/dedent line |

## Telescope

| Key | Action |
|-----|--------|
| `leader + f` | Open find menu |
| `Ctrl + n/p` | Next/prev result |
| `Enter` | Open file |
| `Ctrl + v` | Open in vertical split |
| `Ctrl + x` | Open in horizontal split |

## Terminal

| Key | Action |
|-----|--------|
| `leader + tf` | Floating terminal |
| `leader + th` | Horizontal terminal |
| `leader + tv` | Vertical terminal |
| `Ctrl + \` | Toggle terminal |

## Misc

| Key | Action |
|-----|--------|
| `leader + w` | Save file |
| `leader + q` | Quit |
| `leader + n` | New file |
| `leader + lS` | Symbols outline |
| `leader + ls` | Document symbols |

## Custom Config

Clipboard is configured with `xclip` for system integration:
- Yank (`y`) copies to system clipboard
- Paste (`p`) pastes from system clipboard

# This resource file assumes the following used
# https://github.com/zsh-users/antigen
# Load Antigen
source ~/.antigen.zsh

# Load Antigen configurations
antigen init ~/.antigenrc

# Enable fzf - or not, thanks for the plugin
# [ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Hook direnv into zsh
eval "$(direnv hook zsh)"

HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt appendhistory

# Created by wasak for 5.8
eval "$(starship init zsh)"

# it's where all kinds of cool stuff live
export PATH="$HOME/.local/bin:$PATH"
export BROWSER=firefox

# node's nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# fly.io
export FLYCTL_INSTALL="$HOME/.fly"
export PATH="$FLYCTL_INSTALL/bin:$PATH"

# rustlings <3
export PATH="$HOME/.cargo/bin:$PATH"

# aliases

# fnm
FNM_PATH="$HOME/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "$(fnm env)"
fi

[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# fnm
FNM_PATH="/home/wasak/.local/share/fnm"
if [ -d "$FNM_PATH" ]; then
  export PATH="$FNM_PATH:$PATH"
  eval "`fnm env`"
fi

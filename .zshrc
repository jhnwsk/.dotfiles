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


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion
# nvm end

# pnpm
export PNPM_HOME="/Users/denishomolik/Library/pnpm"
export PATH="$PNPM_HOME:$PATH"
# pnpm end

alias ls='eza'
alias beep='echo -en "\007"'

source ~/.signageos/sosa.sh

# General Shell Aliases
alias ls='ls --color=auto'
alias ll='ls -l --color=auto'
alias la='ls -A --color=auto'
alias l='ls -CFlh --color=auto'

# Safety aliases (prompts before overwriting)
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'

# Updates
alias update='sudo apt update && sudo apt upgrade -y'

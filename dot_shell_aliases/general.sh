# General Shell Aliases
alias ls='ls --color=auto'
alias ll='ls -la --color=auto'
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

# System shortcuts
alias please="sudo"
alias ports="lsof -i -P -n | grep LISTEN"
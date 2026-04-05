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
alias please="sudo"i

# port management
alias wtfport='f() { lsof -i tcp:$1; }; f'  # src: https://ericmjl.github.io/data-science-bootstrap-notes/shell/aliases/
alias killport='f() { lsof -ti:$1 | xargs kill -9; }; f'  # src: https://ericmjl.github.io/data-science-bootstrap-notes/shell/aliases/
alias ports="lsof -i -P -n | grep LISTEN"
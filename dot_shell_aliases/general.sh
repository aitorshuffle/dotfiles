# General Shell Aliases (powered by eza)
alias ls='eza --icons --color-scale -o'
alias ll='eza -la --icons --group-directories-first --color-scale -o'
alias la='eza -a --icons --group-directories-first --color-scale -o'
alias l='eza -la --icons --group-directories-first --header --color-scale -o'

# File viewing
alias cat='bat'

# Safety aliases (prompts before overwriting)
alias cp='cp -i'
alias mv='mv -i'

# Navigation
alias ..='cd ..'
alias ...='cd ../..'

# Updates
alias update='sudo apt update && sudo apt upgrade -y'

# System shortcuts
alias please="sudo"

# port management
alias wtfport='f() { lsof -i tcp:$1; }; f'  # src: https://ericmjl.github.io/data-science-bootstrap-notes/shell/aliases/
alias killport='f() { lsof -ti:$1 | xargs kill -9; }; f'  # src: https://ericmjl.github.io/data-science-bootstrap-notes/shell/aliases/
alias ports="lsof -i -P -n | grep LISTEN"
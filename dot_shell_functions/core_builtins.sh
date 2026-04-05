# Enhanced built-in commands
# (from https://ericmjl.github.io/data-science-bootstrap-notes/shell/aliases/)

# Automatically list contents after changing directories
cd() { 
    command cd "$@" && ls 
}

# Safely print what is being deleted before executing RM entirely
rm() { 
    echo "Deleting: $@"
    command rm "$@" 
}

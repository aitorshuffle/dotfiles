# Enhanced built-in commands
# (from https://ericmjl.github.io/data-science-bootstrap-notes/shell/aliases/)

# Automatically list contents after changing directories
cd() { 
    command cd "$@" && ls 
}

# Safely print what is being deleted before executing RM entirely
# We also natively inject -i here so you don't lose that safety net!
rm() { 
    echo "Deleting: $@"
    command rm -i "$@" 
}

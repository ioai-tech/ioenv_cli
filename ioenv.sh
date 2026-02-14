# Detect current shell and set source file path accordingly
if [ -n "$BASH_VERSION" ]; then
    # Running in bash
    cd "$(dirname "$BASH_SOURCE")"
    CUR_FILE=$(pwd)/$(basename "$BASH_SOURCE")
    CUR_DIR=$(dirname "$CUR_FILE")
    cd - > /dev/null
elif [ -n "$ZSH_VERSION" ]; then
    # Running in zsh
    CUR_FILE="${(%):-%x}"
    CUR_FILE="${CUR_FILE:a}"  # Convert to absolute path
    CUR_DIR=$(dirname "$CUR_FILE")
else
    # Fallback for other shells
    echo "$0" | grep -q "$PWD"
    if [ $? -eq 0 ]; then
        CUR_FILE=$0
    else
        CUR_FILE=$(pwd)/$0
    fi
    CUR_DIR=$(dirname "$CUR_FILE")
fi

# Add PATH
if [ -z "$(echo $PATH | grep $CUR_DIR/bin)" ]; then
    export PATH=$CUR_DIR/bin:$PATH
fi

# Shell-specific completions
if [ -n "$BASH_VERSION" ]; then
    # Bash completion
    complete -W "run start stop restart remove purge pull sshopen sshpassword list create help" ioenv
elif [ -n "$ZSH_VERSION" ]; then
    # Zsh completion
    autoload -U compinit && compinit
    _ioenv_completion() {
        local -a subcmds
        subcmds=('run' 'start' 'stop' 'restart' 'remove' 'purge' 'pull' 'sshopen' 'sshpassword' 'list' 'create' 'help')
        _describe 'ioenv commands' subcmds
    }
    compdef _ioenv_completion ioenv
fi

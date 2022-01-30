# Setup fzf
# ---------
if [[ ! "$PATH" == */home/pablo/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/pablo/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/pablo/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/pablo/.fzf/shell/key-bindings.zsh"

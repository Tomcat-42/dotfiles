# Setup fzf
# ---------
if [[ ! "$PATH" == */home/pablo951_br/.fzf/bin* ]]; then
  export PATH="${PATH:+${PATH}:}/home/pablo951_br/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/pablo951_br/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/pablo951_br/.fzf/shell/key-bindings.zsh"

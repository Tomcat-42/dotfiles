function fish_user_key_bindings
    fzf --fish | source
    bind -M default \cz 'fg 2>/dev/null; commandline -f repaint'
    bind -M insert \cz 'fg 2>/dev/null; commandline -f repaint'
end

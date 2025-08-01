set -U fish_greeting
set -U fish_command_not_found

if status is-login
    dbus-run-session river -no-xwayland -log-level error
    # dbus-run-session river -log-level error
    # dbus-run-session river -log-level error
end

if status is-interactive
    set -g fish_key_bindings fish_vi_key_bindings
    zoxide init fish | source
    fzf --fish | source

    if type -q tmux
        if not set -q TMUX
            tmux
        end

        while not set -q TMUX
            tmux attach || break
        end
    end
end

if status is-login
    eval $(ssh-agent -c)
    dbus-run-session river -no-xwayland -log-level error
end

set -gx MODULEPATH /opt/nvidia/hpc_sdk/modulefiles $MODULEPATH

if status is-interactive
    set -g fish_key_bindings fish_vi_key_bindings

    if type -q zoxide
        zoxide init fish | source
        bind ctrl-g zi repaint
        bind alt-l zi repaint
    end

    if type -q tmux
        if not set -q TMUX
            tmux
        end

        while not set -q TMUX
            tmux attach || break
        end
    end
end

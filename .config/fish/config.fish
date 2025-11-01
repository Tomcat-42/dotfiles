set -U fish_greeting
set -U fish_command_not_found

if status is-login
    eval $(ssh-agent -c)
    dbus-run-session river -no-xwayland -log-level error
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

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

# ZVM
set -gx ZVM_INSTALL "$HOME/.zvm/self"
set -gx PATH $PATH "$HOME/.zvm/bin"
set -gx PATH $PATH "$ZVM_INSTALL/"

set -gx WASMTIME_HOME "$HOME/.wasmtime"

string match -r ".wasmtime" "$PATH" > /dev/null; or set -gx PATH "$WASMTIME_HOME/bin" $PATH

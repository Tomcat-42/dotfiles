# --- Editors ---
set -gx EDITOR nvim
set -gx VISUAL nvim
set -gx SYSTEMD_EDITOR nvim
set -gx SUDO_EDITOR "$HOME/.local/share/bob/nvim-bin/nvim"
type -q bat && set -gx MANPAGER "bat -plman" && set -gx PAGER "bat --plain"
type -q nvim && set -gx MANPAGER "nvim -c 'Man!' -o -"

# --- Locale ---
set -gx LANG "en_US.UTF-8"
set -gx LC_ALL "en_US.UTF-8"
set -gx LC_CTYPE "en_US.UTF-8"
set -gx LANGUAGE "en_US.UTF-8"

# --- Desktop / Wayland ---
set -gx XDG_CURRENT_DESKTOP river
set -gx XDG_SESSION_TYPE wayland
set -gx QT_QPA_PLATFORM wayland
set -gx QT_QPA_PLATFORMTHEME qt5ct
set -gx CLUTTER_BACKEND wayland
set -gx SDL_VIDEODRIVER wayland
set -gx ELECTRON_OZONE_PLATFORM_HINT wayland
set -gx GTK_USE_PORTAL 1
set -gx GTK_THEME "Gruvbox-Red-Dark:dark"
set -gx GTK_CSD 0
set -gx LIBSEAT_BACKEND logind
set -gx NO_AT_BRIDGE 1
set -gx DBUS_SESSION_BUS_ADDRESS "unix:path=/run/user/"(id -u)"/bus"
set -gx TERMINAL ghostty
set -gx TERMINAL_EXEC "ghostty -e"
set -gx TERMCMD "ghostty -e"
set -gx BROWSER chromium-browser
set -gx CHROMIUM_USER_FLAGS "--disable-vulkan --enable-features=UseOzonePlatform,VerticalTabs --ozone-platform=wayland"
set -gx BEMENU_OPTS "-b -C -i -w -T -l '10 top' --binding vim i --fork -f -P '=>' -p '' --vim-esc-exits -B 2.0 --bdr '#$color08' -R 0 -n --fn 'Berkeley Nerd Font 10' --tb #$color00 --tf #$color05 --fb #$color00 --ff #$color05 --cb #$color00 --cf #$color05 --nb #$color00 --nf #$color05 --hb #$color00 --hf #$color0B --fbb #$color00 --fbf #$color0A --ab #$color00 --af #$color05"
set -gx SUDO_PROMPT (set_color green --bold)"[passwd]: "(set_color normal)

# --- Compilers ---
set -gx CC /usr/bin/clang
set -gx CXX /usr/bin/clang++

# --- Toolchains ---
set -gx GOPATH "$HOME/.local/share/go"
set -gx DEVKITPRO /opt/devkitpro
set -gx DEVKITARM $DEVKITPRO/devkitARM
set -gx DEVKITPPC $DEVKITPRO/devkitPPC
set -gx ANDROID_HOME "$HOME/.local/opt/android-sdk"
set -gx JAVA_HOME /usr/lib/jvm/java-21-openjdk
set -gx CHROME_EXECUTABLE (command -s chromium-browser)
set -gx _JAVA_AWT_WM_NONREPARENTING 1
set -gx QMK_HOME "$HOME/dev/qmk_firmware"
set -gx WASMTIME_HOME "$HOME/.wasmtime"
set -gx KRB5CCNAME "FILE:/tmp/krb5cc_$(id -u)"
set -gx DEBUGINFOD_URLS "https://debuginfod.archlinux.org"
set -gx PSPDEV "$HOME/.local/opt/pspdev"

set -gx LUA_PATH "/usr/share/lua/5.4/?.lua;/usr/local/share/lua/5.4/?.lua;/usr/local/share/lua/5.4/?/init.lua;/usr/share/lua/5.4/?/init.lua;/usr/local/lib/lua/5.4/?.lua;/usr/local/lib/lua/5.4/?/init.lua;/usr/lib/lua/5.4/?.lua;/usr/lib/lua/5.4/?/init.lua;./?.lua;./?/init.lua;$HOME/.luarocks/share/lua/5.4/?.lua;$HOME/.luarocks/share/lua/5.4/?/init.lua"
set -gx LUA_CPATH "/usr/local/lib/lua/5.4/?.so;/usr/lib/lua/5.4/?.so;/usr/local/lib/lua/5.4/loadall.so;/usr/lib/lua/5.4/loadall.so;./?.so;$HOME/.luarocks/lib/lua/5.4/?.so"

set -gx GUILE_LOAD_COMPILED_PATH "/usr/lib/guile/3.0/ccache/:/usr/local/lib/guile/3.0/site-ccache/"
set -gx GUILE_LOAD_PATH "/usr/share/guile/3.0/:/usr/local/share/guile/site/3.0"

# --- Hardware / Video ---
set -gx LIBVA_DRIVER_NAME iHD
set -gx VDPAU_DRIVER va_gl
set -gx ANV_DEBUG "video-decode,video-encode"

# --- FZF ---
# Color vars ($color00–$color0F) set by conf.d/colors.fish (loads first alphabetically)
set -gx FZF_DEFAULT_OPTS \
    " --style minimal"\
" --color=bg+:#$color01,bg:#$color00,spinner:#$color0C,hl:#$color0D"\
" --color=fg:#$color04,header:#$color0D,info:#$color0A,pointer:#$color0C"\
" --color=marker:#$color0C,fg+:#$color06,prompt:#$color0A,hl+:#$color0D"

set -gx FZF_CTRL_T_OPTS \
    " --style minimal"\
" --walker-skip .git,node_modules,target"\
" --preview 'bat -n --color=always {}'"\
" --bind 'ctrl-/:change-preview-window(down|hidden|)'"

set -gx FZF_CTRL_R_OPTS \
    " --style minimal"\
" --reverse"\
" --preview 'echo {2..} | bat --color=always -pl sh'"\
" --bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'"\
" --color header:italic"\
" --header 'Press CTRL-Y to copy command into clipboard'"

set -gx FZF_ALT_C_OPTS \
    " --style minimal"\
" --walker-skip .git,node_modules,target"\
" --preview 'tree -C {}'"

# --- Docker / Podman ---
set -gx DOCKER_HOST "unix://$XDG_RUNTIME_DIR/podman/podman.sock"

# --- Claude Code ---
set -gx CLAUDE_CODE_USE_VERTEX 1
set -gx CLOUD_ML_REGION global
set -gx ANTHROPIC_VERTEX_PROJECT_ID itpc-gcp-core-pe-eng-claude

# --- Libvirt ---
set -gx LIBVIRT_DEFAULT_URI "qemu:///system"

# --- Misc ---
set -gx PASSWORD_STORE_DIR $HOME/data/documents/other/passwords
set -gx BAT_THEME base16

# --- Ocaml ---
test -r '/home/phugen/.opam/opam-init/init.fish' && source '/home/phugen/.opam/opam-init/init.fish' >/dev/null 2>/dev/null; or true

# --- PATH ---
set paths \
    $GOPATH/bin \
    $HOME/.fzf/bin \
    $HOME/scripts \
    $HOME/.cargo/bin \
    $HOME/.local/share/bob/nvim-bin \
    $HOME/.zvm/bin \
    $HOME/.zvm/self \
    $HOME/.local/bin \
    $HOME/.luarocks/bin \
    /usr/libexec/podman/ \
    /opt/qmk_toolchains_linuxX64/bin/ \
    $HOME/.local/opt/luals/bin \
    $HOME/.local/opt/codelldb/extension/bin \
    $HOME/.local/opt/codelldb/extension/adapter \
    $HOME/.local/opt/flutter/bin \
    $ANDROID_HOME/cmdline-tools/latest/bin \
    $ANDROID_HOME/platform-tools \
    $ANDROID_HOME/emulator \
    $HOME/.bun/bin \
    $HOME/.radicle/bin \
    $HOME/.local/opt/ghidra \
    $DEVKITPRO/tools/bin \
    $WASMTIME_HOME/bin \
    $PSPDEV/bin
fish_add_path $paths

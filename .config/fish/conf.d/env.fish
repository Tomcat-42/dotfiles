set -gx EDITOR "nvim"
set -gx BROWSER "luakit"
set -gx PAGER "bat"
# set -gx TERM "screen-256color"
set -gx VISUAL "nvim"
set -gx TERMINAL_EXEC  "kitty"
set -gx BEMENU_OPTS  "-C -i -w -T -b -l '10 up' --binding vim i --fork -f -P '=>' -p '' --vim-esc-exits -B 2.0 --bdr '#$color0E' -R 0 -n --fn 'Iosevka Nerd Font' --tb #$color00 --tf #$color05 --fb #$color00 --ff #$color05 --cb #$color00 --cf #$color05 --nb #$color00 --nf #$color05 --hb #$color00 --hf #$color0B --fbb #$color00 --fbf #$color0% --ab #$color00 --af #$color05"
set -gx NO_AT_BRIDGE  "1"
set -gx PASSWORD_STORE_DIR  "/home/pablo/data/documents/other/passwords"
set -gx BAT_THEME  "base16"
set -gx _JAVA_AWT_WM_NONREPARENTING  "1"


set -gx CC "/usr/bin/clang"
set -gx CXX "/usr/bin/clang++"
set -gx TERMINAL "kitty"
set -gx XDG_CURRENT_DESKTOP "river"
set -gx XDG_SESSION_TYPE "wayland"
set -gx GTK_USE_PORTAL 1
set -gx QT_QPA_PLATFORM "wayland"
set -gx NO_AT_BRIDGE 1
set -gx QT_QPA_PLATFORMTHEME "qt5ct"
set -gx CLUTTER_BACKEND "wayland"
set -gx SDL_VIDEODRIVER "wayland"
set -gx ELECTRON_OZONE_PLATFORM_HINT "wayland"
set -gx GTK_THEME "FlatColor"
set -gx GTK_CSD 0
set -gx LD_PRELOAD /usr/lib/libgtk3-nocsd.so.0
set -gx LIBSEAT_BACKEND "logind"
set -gx LC_CTYPE "pt_BR.UTF-8"
set -gx VDPAU_DRIVER "nvidia"
set -gx DEBUGINFOD_URLS "https://debuginfod.archlinux.org"

set -l FZF_NON_COLOR_OPTS

for arg in (echo $FZF_DEFAULT_OPTS | tr " " "\n")
    if not string match -q -- "--color*" $arg
        set -a FZF_NON_COLOR_OPTS $arg
    end
end

set -Ux FZF_DEFAULT_OPTS "$FZF_NON_COLOR_OPTS"\
" --color=bg+:#$color01,bg:#$color00,spinner:#$color0C,hl:#$color0D"\
" --color=fg:#$color04,header:#$color0D,info:#$color0A,pointer:#$color0C"\
" --color=marker:#$color0C,fg+:#$color06,prompt:#$color0A,hl+:#$color0D"

set paths \
    ~/.local/bin \
    ~/go/bin \
    ~/scripts \
    ~/.cargo/bin \
    ~/.local/share/bob/nvim-bin \
    /usr/lib/llvm16/bin \
    ~/dev/bun/build/debug/ \
    ~/dev/bun/build/release \
    ~/.zvm/bin

fish_add_path $paths

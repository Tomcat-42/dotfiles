set -gx EDITOR nvim
set -gx BROWSER chromium
set -gx PAGER bat
# set -gx TERM "screen-256color"
set -gx VISUAL nvim
set -gx TERMINAL_EXEC "ghostty -e"
set -gx TERMCMD "ghostty -e"
set -gx TERMINAL ghostty
set -gx BEMENU_OPTS "-C -i -w -T -b -l '10 up' --binding vim i --fork -f -P '=>' -p '' --vim-esc-exits -B 2.0 --bdr '#$color0E' -R 0 -n --fn 'Iosevka Nerd Font' --tb #$color00 --tf #$color05 --fb #$color00 --ff #$color05 --cb #$color00 --cf #$color05 --nb #$color00 --nf #$color05 --hb #$color00 --hf #$color0B --fbb #$color00 --fbf #$color0% --ab #$color00 --af #$color05"
set -gx NO_AT_BRIDGE 1
set -gx PASSWORD_STORE_DIR /home/pablo/data/documents/other/passwords
set -gx BAT_THEME base16
set -gx _JAVA_AWT_WM_NONREPARENTING 1

set -gx CC /usr/bin/clang
set -gx CXX "/usr/bin/clang++"
set -gx XDG_CURRENT_DESKTOP river
set -gx XDG_SESSION_TYPE wayland
set -gx GTK_USE_PORTAL 1
set -gx QT_QPA_PLATFORM wayland
set -gx NO_AT_BRIDGE 1
set -gx QT_QPA_PLATFORMTHEME qt5ct
set -gx CLUTTER_BACKEND wayland
set -gx SDL_VIDEODRIVER wayland
set -gx ELECTRON_OZONE_PLATFORM_HINT wayland
set -gx GTK_THEME FlatColor
set -gx GTK_CSD 0
set -gx LD_PRELOAD /usr/lib/libgtk3-nocsd.so.0
set -gx LIBSEAT_BACKEND logind
set -gx LC_CTYPE "pt_BR.UTF-8"
set -gx VDPAU_DRIVER nvidia
set -gx DEBUGINFOD_URLS "https://debuginfod.archlinux.org"
set -gx DBUS_SESSION_BUS_ADDRESS "unix:path=/run/user/1000/bus"

set -l FZF_NON_COLOR_OPTS

for arg in (echo $FZF_DEFAULT_OPTS | tr " " "\n")
    if not string match -q -- "--color*" $arg
        set -a FZF_NON_COLOR_OPTS $arg
    end
end

#" --preview 'fzf-preview.sh {}' --bind 'focus:transform-header:file --brief {}'"\
set -Ux FZF_DEFAULT_OPTS \
    " --style minimal"\
" --color=bg+:#$color01,bg:#$color00,spinner:#$color0C,hl:#$color0D"\
" --color=fg:#$color04,header:#$color0D,info:#$color0A,pointer:#$color0C"\
" --color=marker:#$color0C,fg+:#$color06,prompt:#$color0A,hl+:#$color0D"

set -Ux FZF_CTRL_T_OPTS \
    " --style minimal"\
" --walker-skip .git,node_modules,target"\
" --preview 'bat -n --color=always {}'"\
" --bind 'ctrl-/:change-preview-window(down|hidden|)'"

set -Ux FZF_CTRL_R_OPTS \
    " --style minimal"\
" --reverse"\
" --preview 'echo {2..} | bat --color=always -pl sh'"\
" --bind 'ctrl-y:execute-silent(echo -n {2..} | wl-copy)+abort'"\
" --color header:italic"\
" --header 'Press CTRL-Y to copy command into clipboard'"

set -Ux FZF_ALT_C_OPTS \
    " --style minimal"\
" --walker-skip .git,node_modules,target"\
" --preview 'tree -C {}'"

set paths \
    ~/.local/bin \
    ~/go/bin \
    ~/.fzf/bin \
    ~/scripts \
    ~/.cargo/bin \
    ~/.local/share/bob/nvim-bin \
    # /usr/lib/llvm16/bin \
    # ~/dev/bun/build/debug/ \
    # ~/dev/bun/build/release \
    ~/.zvm/bin \
    ~/.zvm/self \
    ~/.luarocks/bin
# for i in (luarocks path | awk '{sub(/PATH=/, "PATH ", $2); print "set -gx "$2}'); eval $i; end

set -gx LUA_PATH '/usr/share/lua/5.4/?.lua;/usr/local/share/lua/5.4/?.lua;/usr/local/sha
re/lua/5.4/?/init.lua;/usr/share/lua/5.4/?/init.lua;/usr/local/lib/lua/5.4/?.lua;/usr/lo
cal/lib/lua/5.4/?/init.lua;/usr/lib/lua/5.4/?.lua;/usr/lib/lua/5.4/?/init.lua;./?.lua;./
?/init.lua;/home/pablo/.luarocks/share/lua/5.4/?.lua;/home/pablo/.luarocks/share/lua/5.4
/?/init.lua'
set -gx LUA_CPATH '/usr/local/lib/lua/5.4/?.so;/usr/lib/lua/5.4/?.so;/usr/local/lib/lua/
5.4/loadall.so;/usr/lib/lua/5.4/loadall.so;./?.so;/home/pablo/.luarocks/lib/lua/5.4/?.so
'

set -gx LIBVA_DRIVER_NAME "nvidia"
set -gx __GLX_VENDOR_LIBRARY_NAME "nvidia"
set -gx NVD_BACKEND "direct"

# set -gx FREETYPE_PROPERTIES \
#     "autofitter:no-stem-darkening=0\
#  autofitter:darkening-parameters=500,0,1000,500,2500,500,4000,0\
#  cff:no-stem-darkening=0\
#  cff:darkening-parameters=500,475,1000,475,2500,475,4000,0\
#  type1:no-stem-darkening=0\
#  type1:darkening-parameters=500,475,1000,475,2500,475,4000,0\
#  t1cid:no-stem-darkening=0\
#  t1cid:darkening-parameters=500,475,1000,475,2500,475,4000,0"

fish_add_path $paths

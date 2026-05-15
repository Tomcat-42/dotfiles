function zig-rebuild --description "Rebuild zig and update zv"
    pushd $HOME/dev/zig/zig/build
    and ninja install
    and $HOME/dev/zig/zig/update-zv.sh
    popd
end

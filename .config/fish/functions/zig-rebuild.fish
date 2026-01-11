function zig-rebuild --description "Rebuild zig and update zv"
    pushd /home/phugen/dev/zig/zig/build
    and ninja install
    and /home/phugen/dev/zig/zig/update-zv.sh
    popd
end

function fish_jj_prompt --description 'Display jj repo status in prompt'
    # Check if jj is installed
    if not command -sq jj
        return 1
    end

    # Single jj call with --ignore-working-copy for speed
    # If this fails, we're not in a jj repo
    set -l info "$(jj log 2>/dev/null --no-graph --ignore-working-copy -r @ \
        -T 'separate(" ",
            bookmarks,
            if(conflict, label("conflict", "(conflict)")),
            if(divergent, label("divergent", "(divergent)")),
            if(!empty, label("working_copy", "+"))
        )'
    )"
    or return 1

    if test -z "$info"
        set info "no bookmarks"
    end

    set_color magenta --bold
    printf ' (%s)' $info
    set_color normal
end

abbr -a pingle ping www.google.com
abbr -a dz detach zathura
abbr -a di detach imv
abbr -a gitsc git commit -S -s --amend --no-edit
abbr -a n nvim
abbr -a h hx
abbr -a d dragon --and-exit
abbr -a npager nvim -R

function dnfz
    set -l cache_file ~/.cache/dnfz_packages
    set -l cache_age 3600

    if test -f $cache_file
        set -l file_age (math (date +%s) - (stat -c %Y $cache_file))
        if test $file_age -lt $cache_age
            set -l use_cache 1
        end
    end

    if set -q use_cache
        cat $cache_file
    else
        dnf repoquery --available --queryformat '%{name}\n' -q 2>/dev/null | sort -u | tee $cache_file
    end | fzf -m \
        --header 'Select packages to install (TAB to multi-select)' \
        --preview 'dnf info {} 2>/dev/null | head -20' \
        --preview-window 'right:50%:wrap' \
        --bind 'ctrl-r:reload(dnf repoquery --available --queryformat "%{name}\n" -q 2>/dev/null | sort -u | tee ~/.cache/dnfz_packages)' \
        | xargs -r sudo dnf install -y
end

function play
    mpv $(ls | bemenu)
end

function c
    if test (count $argv) -eq 0
        echo "Usage: c <path>"
        return 1
    end
    mkdir -p -- $argv[1]
    cd -- $argv[1]
end

function ct
    cd "$(mktemp -d)"
end

function git_gone
    for branch in (git branch --merged | string trim | grep -v '^\*' | grep -v -E '^(master|main)$')
        git branch -d $branch
    end
end

function git_logmsgs
    git log --pretty=format:"%h»¦«%aN»¦«%s»¦«%aD" |
        string split '\n' |
        while read line
            echo $line | string split '»¦«'
        end | head -n 10
end

function git_contribs
    git log --pretty=format:"%h»¦«%aN»¦«%s»¦«%aD" |
        string split '\n' |
        while read line
            set parts (echo $line | string split '»¦«')
            echo $parts[2]
        end |
        sort |
        uniq -c |
        sort -nr
end

function gitz_checkout
    git branch --sort=-committerdate --format='%(refname:short)' | \
        fzf --height 40% \
        --header 'Checkout branch' \
        --preview 'git log --oneline -15 {}' \
        --preview-window 'right:50%:wrap' \
        | xargs -r git checkout
end

function gitz_add
    git diff --name-only --diff-filter=ACMR | \
        fzf -m \
        --header 'Stage files (TAB to multi-select)' \
        --preview 'git diff --color=always {}' \
        --preview-window 'right:60%:wrap' \
        | xargs -r git add
    and git status -s
end

function gitz_log
    git log --oneline --color=always -50 | \
        fzf --ansi \
        --header 'Browse commits (enter to show)' \
        --preview 'git show --color=always --stat {1}' \
        --preview-window 'right:60%:wrap' \
        --bind 'enter:execute(git show --color=always {1} | less -R)'
end

function gitz_stash
    git stash list --color=always | \
        fzf --ansi \
        --header 'Stashes (enter to show, ctrl-a to apply, ctrl-d to drop)' \
        --preview 'git stash show --color=always -p (echo {} | grep -o "stash@{[0-9]*}")' \
        --preview-window 'right:60%:wrap' \
        --bind 'enter:execute(git stash show --color=always -p (echo {} | grep -o "stash@{[0-9]*}") | less -R)' \
        --bind 'ctrl-a:execute(git stash apply (echo {} | grep -o "stash@{[0-9]*}"))' \
        --bind 'ctrl-d:execute(git stash drop (echo {} | grep -o "stash@{[0-9]*}"))'
end

function ytclip
    if test (count $argv) -lt 1
        echo "Usage: ytclip <url> [output_file] [start_time] [end_time]"
        echo "Examples:"
        echo "  ytclip 'https://youtube.com/...'"
        echo "  ytclip 'https://youtube.com/...' myfile.mp3"
        echo "  ytclip 'https://youtube.com/...' 00:18 00:20"
        echo "  ytclip 'https://youtube.com/...' myfile.mp3 00:18 00:20"
        return 1
    end

    set url $argv[1]

    switch (count $argv)
        case 1
            set output "out.mp3"
            set start_time ""
            set end_time ""
        case 2
            set output $argv[2]
            set start_time ""
            set end_time ""
        case 3
            set output "out.mp3"
            set start_time $argv[2]
            set end_time $argv[3]
        case 4
            set output $argv[2]
            set start_time $argv[3]
            set end_time $argv[4]
    end

    yt-dlp -x --audio-format mp3 --audio-quality 0 -o "temp_ytclip.%(ext)s" "$url"

    if test -n "$start_time" -a -n "$end_time"
        ffmpeg -i temp_ytclip.mp3 -ss "$start_time" -to "$end_time" -c copy "$output"
        rm -f temp_ytclip.mp3
    else
        mv temp_ytclip.mp3 "$output"
    end
end

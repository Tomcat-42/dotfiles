alias dz 'detach zathura'
alias di 'detach imv'
alias pingle 'gping www.google.com'
alias gitsc 'git commit -S -s --amend --no-edit'
alias diff 'delta'
alias nv 'nvim'
# alias ls 'lsd'

function c
    if test (count $argv) -eq 0
        echo "Usage: c <path>"
        return 1
    end
    mkdir -p -- $argv[1]
    cd -- $argv[1]
end

# Function 'git_gone' to delete merged Git branches except 'master' and 'main'
function git_gone
    for branch in (git branch --merged | string trim | grep -v '^\*' | grep -v -E '^(master|main)$')
        git branch -d $branch
    end
end

# Function 'git_logmsgs' to display the latest 10 commit messages
function git_logmsgs
    git log --pretty=format:"%h»¦«%aN»¦«%s»¦«%aD" |
    string split '\n' |
    while read line
        echo $line | string split '»¦«'
    end | head -n 10
end

# Function 'git_contribs' to show a histogram of committers and mergers
function git_contribs
    git log --pretty=format:"%h»¦«%aN»¦«%s»¦«%aD" |
    string split '\n' |
    while read line
        set parts (echo $line | string split '»¦«')
        echo $parts[2]  # Assuming the committer is the second field
    end |
    sort |
    uniq -c |
    sort -nr
end

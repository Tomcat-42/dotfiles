function fish_vcs_prompt --description 'Print VCS prompt (jj first, then git)'
    # Try jj first (for jj repos, including colocated ones)
    fish_jj_prompt $argv
    and return

    # Fall back to git
    fish_git_prompt $argv
end

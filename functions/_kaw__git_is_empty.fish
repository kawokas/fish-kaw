function _kaw__git_is_empty -d "Test if a repository is empty"
    if command git rev-list -n 1 --all > /dev/null ^ /dev/null
        return 1
    end

     _kaw__git_is_repo
end

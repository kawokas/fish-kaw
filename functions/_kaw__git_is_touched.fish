function _kaw__git_is_touched -d "Test if there are any changes in the working tree"
    if not _kaw__git_is_repo
        return 1
    end

    command git status --porcelain ^ /dev/null | command awk '
        // {
            z++
            exit 0
        }

        END {
            exit !z
        }
    '
end

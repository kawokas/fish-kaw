
function _kaw__pwd_info -a separator -d "Print info about the current working directory"
    set -l home ~
    set -l git_root (command git rev-parse --show-toplevel ^ /dev/null)

    echo "$PWD" | awk -v home="$home" -v git_root="$git_root" -v separator="$separator" '
        function base(string) {
            sub(/^\/?.*\//, "", string)
            return string
        }

        function dirs(string, printLastName,   prefix, path) {
            len = split(string, parts, "/")

            for (i = 1; i < len; i++) {
                name = substr(parts[i], 1, 1)

                if (parts[i] == "" || name == ".") {
                    continue
                }

                path = path prefix name
                prefix = separator
            }

            return (printLastName == 1) ? path prefix parts[len] : path
        }

        function remove(thisString, fromString) {
            sub(thisString, "", fromString)
            return fromString
        }

        {
            if (git_root == home) {
                git_root = ""
            }
            if (git_root == "") {
                printf("%s\n%s\n%s\n",
                    $0 == home || $0 == "/" ? "" : base($0),
                    dirs(remove(home, $0)),
                    "")
            } else {
                printf("%s\n%s\n%s\n",
                    base(git_root),
                    dirs(remove(home, git_root)),
                    $0 == git_root ? "" : dirs(remove(git_root, $0), 1))
            }
        }
    '
end

function _kaw__pwd_is_home -d "Test if cwd equals or is a child of HOME"
    switch "$PWD"
        case ~{,/\*}
            return 0
    end
    return 1
end

function _kaw__git_ahead -a ahead behind diverged none
    command git rev-list --count --left-right "@{upstream}...HEAD" ^ /dev/null | command awk "
        /0\t0/          { print \"$none\"       ? \"$none\"     : \"\";    exit 0 }
        /[0-9]+\t0/     { print \"$behind\"     ? \"$behind\"   : \"-\";    exit 0 }
        /0\t[0-9]+/     { print \"$ahead\"      ? \"$ahead\"    : \"+\";    exit 0 }
        //              { print \"$diverged\"   ? \"$diverged\" : \"±\";    exit 0 }
    "
end

function _kaw__git_branch_name -d "Get the name of the current Git branch, tag or sha1"
    set -l branch_name (command git symbolic-ref --short HEAD ^/dev/null)

    if test -z "$branch_name"
        set -l tag_name (command git describe --tags --exact-match HEAD ^ /dev/null)

        if test -z "$tag_name"
            command git rev-parse --short HEAD ^ /dev/null
        else
            printf "%s\n" "$tag_name"
        end
    else
        printf "%s\n" "$branch_name"
    end
end

function _kaw__git_is_detached_head -d "Test if the repository is in a detached HEAD state"
    if command git symbolic-ref HEAD ^ /dev/null > /dev/null
        return 1
    end

    _kaw__git_is_repo
end

function _kaw__git_is_dirty -d "Test if there are changes not staged for commit"
    if command git diff --no-ext-diff --quiet --exit-code ^ /dev/null
        return 1
    end

    _kaw__git_is_repo
end

function _kaw__git_is_empty -d "Test if a repository is empty"
    if command git rev-list -n 1 --all > /dev/null ^ /dev/null
        return 1
    end

     _kaw__git_is_repo
end

function _kaw__git_is_repo -d "Test if the current directory is a Git repository"
    if not command git rev-parse --git-dir > /dev/null ^ /dev/null
        return 1
    end
end

function _kaw__git_is_staged -d "Test if there are changes staged for commit"
    if command git diff --cached --no-ext-diff --quiet --exit-code ^ /dev/null
        return 1
    end

    _kaw__git_is_repo
end

function _kaw__git_is_stashed -d "Test if there are changes in the Git stash"
    command git rev-parse --verify --quiet refs/stash > /dev/null ^ /dev/null
end

function _kaw__git_is_tag -d "Test if HEAD is on top of a tag (can be simple, annotated or signed)"
    if git_is_detached_head
        and command git describe --tags --exact-match HEAD ^ /dev/null > /dev/null
        return 0
    else
        return 1
    end
end

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

function _kaw__git_repository_root -d "Get the top level directory of the current git repository"
    if not _kaw__git_is_repo
        return 1
    end

    command git rev-parse --show-toplevel
end

function _kaw__git_untracked_files -d "Get the number of untracked files in a repository"
    if not _kaw__git_is_repo
        return 1
    end

    command git ls-files --others --exclude-standard | awk '

        BEGIN {
            n = 0
        }

        { n++ }

        END {
            print n
            exit !n
        }
    '
end

function _kaw__last_job_id -d "Get the id of one or more existing jobs"
    builtin jobs $argv | command awk -v FS=\t '
        /[0-9]+\t/{
            aJobs[++nJobs] = $1
        }
        END {
            for (i = 1; i <= nJobs; i++) {
                print(aJobs[i])
            }

            exit nJobs == 0
        }
    '
end

function _kaw__host_info -d "Get user and host / domain information" -a format
    set -l host (hostname)
    command id -un | command awk -v host="$host" -v format="$format" '

        BEGIN {
            if (format == "") {
                format = "user@host"
            }
        }

        {
            user = $0

            if (!sub("usr", substr(user, 1, 1), format)) {
                sub("user", user, format)
            }

            len = split(host, host_info, ".")

            sub("host", host_info[1], format)
            sub("domain", len > 1 ? host_info[2] : "", format)

            print(format)
        }
    '
end

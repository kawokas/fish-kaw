# sol: https://github.com/jorgebucaran/fish-sol
# Copyright (c) 2016 Jorge Bucaran

function fish_right_prompt
    set -l status_copy $status
    set -l pwd_info (pwd_info "/")
    set -l dir
    set -l base

    set -l color (set_color $kaw_color_normal)
    set -l color2 (set_color $kaw_color_gray)

    set -l color_error (set_color $fish_color_error)
    set -l color_normal (set_color $fish_color_gray)

    echo -sn " "

    if test "$status_copy" -ne 0
        set color "$color_error"
        set color2 "$color_error"
    end

    if test 0 -eq (id -u "$USER")
        echo -sn "$color_error\$ $color_normal"
    end

    if test ! -z "$SSH_CLIENT"
        set -l color "$color2"

        if test 0 -eq (id -u "$USER")
            set color "$color_error"
        end

        echo -sn "$color"(host_info "usr@")"$color_normal"
    end

    if test "$PWD" = ~
        set base (set_color $kaw_color_dark_green)"~"

    else if pwd_is_home
        set dir
    else
        if test "$PWD" != /
            set dir "/"
        end

        set base "$color_error/"
    end

    if test ! -z "$pwd_info[1]"
        set base "$pwd_info[1]"
    end

    if test ! -z "$pwd_info[2]"
        set dir "$dir$pwd_info[2]/"
    end

    echo -sn "$color2$dir$color2$base$color_normal"

    if test ! -z "$pwd_info[3]"
        echo -sn "$color/$pwd_info[3]"
    end

    if set branch_name (git_branch_name)
        set -l git_color "$color_normal"
        set -l git_glyph "╍"

        if git_is_staged
            set git_color (set_color $kaw_color_dark_green)

            if git_is_dirty
                set git_glyph "$git_color$git_glyph$color_error$git_glyph"
                set git_color "$color_error"
            end

        else if git_is_dirty
            set git_color "$color_error"

        else if git_is_touched
            set git_color "$color_error"
        else
            set git_color (set_color $kaw_color_dark_green)
        end

        set -l git_ahead (git_ahead "+" "-" "+-")

        if test "$branch_name" = "master" -o "$branch_name" = "main"
            set branch_name
            if git_is_stashed
                set branch_name "{}"
            end
        else
            set -l left_par "("
            set -l right_par ")"

            set branch_name_awk '{
                len=split($0, arr, "/");
                name="";
                for(i=1; i<=len; ++i) {
                  if (i == len) {
                    dirname = arr[i]
                  } else {
                    match(arr[i], /^./);
                    dirname = substr(arr[i], RSTART, RLENGTH)
                  }
                  if(name == "") {
                    name = dirname
                  }else {
                    name = sprintf("%s/%s",name,dirname);
                  }
                }
                print name
              }'
            set branch_name (echo $branch_name | awk $branch_name_awk)
            set branch_name " $git_color$left_par$color$branch_name$git_color$right_par"
        end

        echo -sn " $git_color$git_glyph$branch_name$git_ahead"
    end

    echo -sn "$color_normal "
    echo -sn ( date "+%H:%M" )
end

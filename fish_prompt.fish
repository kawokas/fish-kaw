function fish_right_prompt
    set -l status_copy $status
    set -l status_code $status_copy

    set -l color_normal (set_color normal)
    set -l color_error (set_color $fish_color_error)
    set -l color "$color_normal"

    echo -sn " "
end

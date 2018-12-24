# see: https://fishshell.com/docs/current/index.html#variables-color
set -g kaw_color_red 'A00E0E'
set -g kaw_color_orange 'CC6612'
set -g kaw_color_yellow 'EAB624'
set -g kaw_color_green '20A874'
set -g kaw_color_blue '23819B'
set -g kaw_color_normal 'A3A3A3'
set -g kaw_color_gray '888888'

set -g kaw_prompt_arrow '❯' #❯›⌁⁍

set -g fish_color_normal $kaw_color_normal # the default color
set -g fish_color_command $kaw_color_green # the color for commands
set -g fish_color_quote $kaw_color_yellow # the color for quoted blocks of text
set -g fish_color_redirection $kaw_color_yellow # the color for IO redirections
set -g fish_color_end $kaw_color_blue # the color for process separators like ';' and '&'
set -g fish_color_error $kaw_color_red  # the color used to highlight potential errors
set -g fish_color_param $kaw_color_normal # the color for regular command parameters
set -g fish_color_comment $kaw_color_normal # the color used for code comments
set -g fish_color_match $kaw_color_yellow # the color used to highlight matching parenthesis
set -g fish_color_search_match $kaw_color_orange # the color used to highlight history search matches
set -g fish_color_operator $kaw_color_yellow # the color for parameter expansion operators like '*' and '~'
set -g fish_color_escape $kaw_color_yellow # the color used to highlight character escapes like '\n' and '\x70'
set -g fish_color_cwd $kaw_color_normal # the color used for the current working directory in the default prompt
set -g fish_color_autosuggestion $kaw_color_gray # the color used for autosuggestions
set -g fish_color_user $kaw_color_normal # the color used to print the current username in some of fish default prompts
set -g fish_color_host $kaw_color_normal # the color used to print the current host system in some of fish default prompts
set -g fish_color_cancel $kaw_color_error # the color for the '^C' indicator on a canceled command

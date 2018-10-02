# Automatically ssh into the kitty window if it's an ssh session

declare-option str ssh_params

define-command -docstring %{kitty-ssh-new [<command>]: create a new kak client for the current session
Optional arguments are passed as arguments to the new client} \
    -params .. \
    -command-completion \
    kitty-ssh-new %{ evaluate-commands %sh{
        if [ -z $kak_opt_ssh_params ]; then
            printf 'prompt "ssh " "set-option global ssh_params %%%%val{text};kitty-ssh-new %s"\n' "$*"
        else
            kitty @ new-window --no-response --window-type $kak_opt_kitty_window_type \
                ssh -t $kak_opt_ssh_params \
                "$(command -v kak 2>/dev/null)" -c "${kak_session}" -e \"$*\" < /dev/null > /dev/null 2>&1 &
        fi
}}

define-command -docstring %{kitty-ssh-new-tab [<arguments>]: create a new tab
All optional arguments are forwarded to the new kak client} \
    -params .. \
    -command-completion \
    kitty-ssh-new-tab %{ evaluate-commands %sh{
        if [ -z $kak_opt_ssh_params ]; then
            printf 'prompt "ssh " "set-option global ssh_params %%%%val{text};kitty-ssh-new-tab %s"\n' "$*"
        else
            kitty @ new-window --no-response --new-tab \
                ssh -t $kak_opt_ssh_params \
                "$(command -v kak 2>/dev/null)" -c "${kak_session}" -e \"$*\" < /dev/null > /dev/null 2>&1 &
        fi
}}

define-command -docstring %{kitty-ssh-repl [<arguments>]: create a new window for repl interaction
All optional parameters are forwarded to the new window} \
    -params .. \
    kitty-ssh-repl %{ evaluate-commands %sh{
        if [ -z $kak_opt_ssh_params ]; then
            printf 'prompt "ssh " "set-option global ssh_params %%%%val{text};kitty-ssh-repl %s"\n' "$*"
        else
            if [ $# -eq 0 ]; then cmd="${SHELL:-/bin/sh}"; else cmd="$*"; fi
            kitty @ new-window --no-response --window-type $kak_opt_kitty_window_type --title kak_repl_window \
                ssh -t $kak_opt_ssh_params \
                cd $PWD \; \
                $cmd < /dev/null > /dev/null 2>&1 &
        fi
}}

evaluate-commands %sh{
    if [ "$TERM" = "xterm-kitty" ] && [ -n "$SSH_CLIENT" ]; then
        echo "
            remove-hooks global kitty-hooks
            alias global new kitty-ssh-new
            alias global new-tab kitty-ssh-new-tab
            alias global focus kitty-focus
            alias global repl kitty-ssh-repl
            alias global send-text kitty-send-text
        "
    fi
}

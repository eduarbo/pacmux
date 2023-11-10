#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

pacmux_sessions(){
    i=1
    while IFS="|" read -r session name; do
        case "$session" in
            1*) printf "%s${name} " "$(ghost $i)" ;;
            *) printf "%s" "$(ghost $i)" ;;
        esac
        i=$(($i+1))
    done <<< "$(tmux list-sessions -F '#{session_attached} | #{session_name}')"
}

pacmux_sessions

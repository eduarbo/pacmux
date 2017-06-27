#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

pacmux_sessions(){
  i=1
  while IFS= read -r session; do
    case "$session" in
      1) printf "%sᗣ #[fg=default,bold]#{session_name} " "$(ghost $i)";;
      *) printf "%sᗣ " "$(ghost $i)";;
    esac
    i=$(($i+1))
  done <<< "$(tmux list-sessions -F '#{session_attached}')"
}

pacmux_sessions

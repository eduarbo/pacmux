#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/pacmux_helpers.sh"

pacmux_overview(){
  i=1
  while IFS= read -r session; do
    case "$session" in
      1) printf "%s ᗣ#[fg=default]  " "$(ghost $i)"
         while IFS= read -r window; do
           case "$window" in
             1) printf "#[fg=yellow,nobold]ᗧ#[fg=default]";;
             2) printf "#[fg=blue,nobold]ᗣ #[fg=default]";;
             3) printf "•";;
             *) printf "·";;
           esac
         done <<< "$(tmux list-windows -F '#{?window_active,1,#{?window_bell_flag,2,#{?window_activity_flag,3,0}}}')"
         ;;
      *) printf "%s ᗣ" "$(ghost $i)";;
    esac
    i=$(($i+1))
  done <<< "$(tmux list-sessions -F '#{session_attached}')"
}

pacmux_overview

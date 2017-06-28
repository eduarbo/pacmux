#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

pacmux_overview(){
  i=1
  while IFS= read -r session; do
    case "$session" in
      1) printf " %s  " "$(ghost $i)"
         while IFS= read -r symbol; do
           case "$symbol" in
             1) pacman;;
             2) blue_ghost;;
             3) printf "#[none]#[%s]•" "$dots_style";;
             *) printf "#[none]#[%s]·" "$dots_style";;
           esac
         done <<< "$(tmux list-windows -F '#{?window_active,1,#{?window_bell_flag,2,#{?window_activity_flag,3,0}}}')"
         ;;
      *) printf " %s" "$(ghost $i)";;
    esac
    i=$(($i+1))
  done <<< "$(tmux list-sessions -F '#{session_attached}')"
}

pacmux_overview

#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/helpers.sh"

pacmux_overview(){
  i=1
  sessions=($(tmux list-sessions -F '#{session_attached} '))
  for session in "${sessions[@]}"; do
    case "$session" in
      1) printf "%s  " "$(ghost $i)"
         windows=($(tmux list-windows -F '#{?window_active,1,#{?window_bell_flag,2,#{?window_activity_flag,3,0}}} '))
         for window in "${windows[@]}"; do
           case "$window" in
             1) pacman;;
             2) blue_ghost;;
             3) printf "#[none]#[%s]•" "$dots_style";;
             *) printf "#[none]#[%s]·" "$dots_style";;
           esac
         done
         printf " "
         ;;
      *) printf "%s " "$(ghost $i)";;
    esac
    i=$(($i+1))
  done
}

pacmux_overview

#!/usr/bin/env bash

# CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

pacmux_overview_replacement_var="\#{pacmux_overview}"
pacmux_sessions_replacement_var="\#{pacmux_sessions}"
pacmux_status_replacement_var="\#{pacmux_status}"
pacmux_pacman_replacement_var="\#{pacmux_pacman}"

pacmux_status="#[fg=white,nobold]#{?window_activity_flag,•,#{?window_bell_flag,#[fg=blue]ᗣ #[fg=white],·}} #[fg=default]"
pacmux_pacman="#[fg=yellow,nobold]ᗧ#[fg=default]"

# source $CURRENT_DIR/scripts/pacmux.sh

ghost(){
  color[0]="yellow"
  color[1]="red"
  color[2]="brightcyan"
  color[3]="brightmagenta"
  echo "#[fg=${color[$1 % 4]},nobold]"
}

pacmux_sessions(){
  i=1
  while IFS= read -r session; do
    case "$session" in
      1) printf "%sᗣ #[fg=default,bold]#{session_name} " "$(ghost $1)";;
      *) printf "%sᗣ " "$(ghost $1)";;
    esac
    i=$(($i+1))
  done <<< "$(tmux list-sessions -F '#{session_attached}')"
}

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

get_tmux_option() {
	local option=$1
	local default_value=$2
	local option_value
  option_value=$(tmux show-option -gqv "$option")
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

set_tmux_option() {
	local option="$1"
	local value="$2"
	tmux set-option -gq "$option" "$value"
}

do_interpolation() {
	local string="$1"
	local interpolated="${string//$pacmux_overview_replacement_var/#(pacmux_overview)}"
	interpolated="${interpolated//$pacmux_sessions_replacement_var/#(pacmux_sessions)}"
	interpolated="${interpolated//$pacmux_status_replacement_var/$pacmux_status}"
	interpolated="${interpolated//$pacmux_pacman_replacement_var/$pacmux_pacman}"
	echo "$interpolated"
}

update_tmux_option() {
	local option="$1"
	local option_value
	local new_option_value

  option_value="$(get_tmux_option "$option")"
  new_option_value="$(do_interpolation "$option_value")"
	set_tmux_option "$option" "$new_option_value"
}

main() {
	update_tmux_option "status-right"
	update_tmux_option "status-left"
	update_tmux_option "window-status-format"
	update_tmux_option "window-status-current-format"
}
main

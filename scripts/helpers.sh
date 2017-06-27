#!/usr/bin/env bash

ghost(){
  styles=(
    $(get_tmux_option "@blinky-style" "fg=red,nobold")
    $(get_tmux_option "@pinky-style" "fg=brightmagenta,nobold")
    $(get_tmux_option "@inky-style" "fg=brightcyan,nobold")
    $(get_tmux_option "@clyde-style" "fg=yellow,nobold")
  )
  echo "#[${styles[$1 % 4]}]"
}

set_tmux_option() {
	local option=$1
	local value=$2
	local flags=$3
	tmux set-option -gq"$flags" "$option" "$value"
}

set_tmux_window_option() {
  set_tmux_option "$1" "$2" "w"
}

get_tmux_option() {
	local option=$1
	local default_value=$2
	local flags=$3
	local option_value="$(tmux show-option -gv"$flags" "$option")"
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

get_tmux_window_option() {
  get_tmux_option "$1" "$2" "w"
}

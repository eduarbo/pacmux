#!/usr/bin/env bash

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

blue_ghost_style=$(get_tmux_option "@pacmux-blue-ghost-style" "none,fg=blue")
pacman_style=$(get_tmux_option "@pacmux-pacman-style" "none,fg=yellow")
dots_style=$(get_tmux_option "@dots-style" "none,fg=white")

pacman(){
  printf "#[%s]ᗧ#[default]" "$pacman_style"
}

blue_ghost(){
  printf "#[%s]ᗣ #[default]" "$blue_ghost_style"
}

status(){
	printf "#[%s]#{?window_last_flag,,#[%s]}#{?window_activity_flag,•,#{?window_last_flag,ᗣ,·}}#[default]" "$blue_ghost_style" "$dots_style"
}

ghost(){
  styles=(
    $(get_tmux_option "@blinky-style" "none,fg=red")
    $(get_tmux_option "@pinky-style" "none,fg=brightmagenta")
    $(get_tmux_option "@inky-style" "none,fg=brightcyan")
    $(get_tmux_option "@clyde-style" "none,fg=yellow")
  )
  printf "%sᗣ#[default]" "#[${styles[$1 % 4]}]"
}

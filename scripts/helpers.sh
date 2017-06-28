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

blue_ghost_style=$(get_tmux_option "@pacmux-blue-ghost-style" "fg=blue")
pacman_style=$(get_tmux_option "@pacmux-pacman-style" "fg=yellow")
dots_style=$(get_tmux_option "@pacmux-dots-style" "fg=white")

pacman(){
  printf "#[none]#[%s]ᗧ#[default]" "$pacman_style"
}

blue_ghost(){
  printf "#[none]#[%s]ᗣ #[default]" "$blue_ghost_style"
}

window_flag(){
	printf "#[none]#[%s]#{?window_bell_flag,,#[none]#[%s]}#{?window_bell_flag,ᗣ,#{?window_activity_flag,•,·}}#[default]" "$blue_ghost_style" "$dots_style"
}

ghost(){
  styles=(
    $(get_tmux_option "@pacmux-blinky-style" "fg=red")
    $(get_tmux_option "@pacmux-pinky-style" "fg=brightmagenta")
    $(get_tmux_option "@pacmux-inky-style" "fg=brightcyan")
    $(get_tmux_option "@pacmux-clyde-style" "fg=yellow")
  )
  printf "#[none]#[%s]ᗣ#[default]" "${styles[$1 % 4]}"
}

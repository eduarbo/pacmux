#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$CURRENT_DIR/scripts/helpers.sh"

_interpolation=(
	"\#{pacmux_overview}"
	"\#{pacmux_sessions}"
	"\#{pacmux_status}"
	"\#{pacmux_pacman}"
)
_commands=(
	"#($CURRENT_DIR/scripts/pacmux_overview.sh #{session_id} #{window_id})"
	"#($CURRENT_DIR/scripts/pacmux_sessions.sh #{session_id})"
	"$(status)"
	"$(pacman)"
)

do_interpolation() {
	local all_interpolated="$1"
	for ((i=0; i<${#_commands[@]}; i++)); do
		all_interpolated=${all_interpolated//${_interpolation[$i]}/${_commands[$i]}}
	done
	echo "$all_interpolated"
}

update_tmux_option() {
	local option=$1
	local option_value=$(get_tmux_option "$option")
	local new_option_value=$(do_interpolation "$option_value")
	set_tmux_option "$option" "$new_option_value"
}

update_tmux_window_option() {
	local option=$1
	local option_value=$(get_tmux_window_option "$option")
	local new_option_value=$(do_interpolation "$option_value")
	set_tmux_window_option "$option" "$new_option_value"
}

main() {
	update_tmux_option "status-right"
	update_tmux_option "status-left"
	update_tmux_window_option "window-status-format"
	update_tmux_window_option "window-status-current-format"
}
main

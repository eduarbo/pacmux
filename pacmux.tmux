#!/usr/bin/env bash

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=scripts/helpers.sh
source "$CURRENT_DIR/scripts/helpers.sh"

_interpolation=(
	"\#{pacmux_overview}"
	"\#{pacmux_sessions}"
	"\#{pacmux_window_flag_zoomed}"
	"\#{pacmux_window_flag}"
	"\#{pacmux_pacman}"
	"\#{pacmux_ghost}"
)
_commands=(
	"#($CURRENT_DIR/scripts/pacmux_overview.sh)"
	"#($CURRENT_DIR/scripts/pacmux_sessions.sh)"
	"$(window_flag_zoomed)"
	"$(window_flag)"
	"$(pacman)"
	"#($CURRENT_DIR/scripts/pacmux_ghost.sh #{window_index})"
)

do_interpolation() {
	local all_interpolated="$1"
	local i
	for ((i = 0; i < ${#_commands[@]}; i++)); do
		all_interpolated=${all_interpolated//${_interpolation[$i]}/${_commands[$i]}}
	done
	echo "$all_interpolated"
}

update_tmux_option() {
	local option="$1"
	local option_value
	option_value=$(get_tmux_option "$option")
	local new_option_value
	new_option_value=$(do_interpolation "$option_value")
	set_tmux_option "$option" "$new_option_value"
}

update_tmux_window_option() {
	local option="$1"
	local option_value
	option_value=$(get_tmux_window_option "$option")
	local new_option_value
	new_option_value=$(do_interpolation "$option_value")
	set_tmux_window_option "$option" "$new_option_value"
}

main() {
	update_tmux_option "status-right"
	update_tmux_option "status-left"
	update_tmux_window_option "window-status-format"
	update_tmux_window_option "window-status-current-format"
}
main

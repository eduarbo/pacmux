#!/usr/bin/env bash

CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

_interpolation=(
	"\#{pacmux_overview}"
	"\#{pacmux_sessions}"
	"\#{pacmux_status}"
	"\#{pacmux_pacman}"
)
_commands=(
	"#($CURRENT_DIR/scripts/pacmux_overview.sh #{session_id} #{window_id})"
	"#($CURRENT_DIR/scripts/pacmux_sessions.sh #{session_id})"
	"#[fg=white,nobold]#{?window_activity_flag,•,#{?window_bell_flag,#[fg=blue]ᗣ #[fg=white],·}}#[fg=default]"
	"#[fg=yellow,nobold]ᗧ#[fg=default]"
)

set_tmux_option() {
	local command=$1
	local option=$2
	local value=$3
	tmux "$command" -gq "$option" "$value"
}

get_tmux_option() {
	local command=$1
	local option=$2
	local default_value=$3
	local option_value="$(tmux "$command" -gv "$option")"
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

do_interpolation() {
	local all_interpolated="$1"
	for ((i=0; i<${#_commands[@]}; i++)); do
		all_interpolated=${all_interpolated//${_interpolation[$i]}/${_commands[$i]}}
	done
	echo "$all_interpolated"
}

update_tmux_option() {
	local option=$1
	local option_value=$(get_tmux_option "show-option" "$option")
	local new_option_value=$(do_interpolation "$option_value")
	set_tmux_option "set-option" "$option" "$new_option_value"
}

update_tmux_window_option() {
	local option=$1
	local option_value=$(get_tmux_option "show-window-option" "$option")
	local new_option_value=$(do_interpolation "$option_value")
	set_tmux_option "set-window-option" "$option" "$new_option_value"
}

main() {
	update_tmux_option "status-right"
	update_tmux_option "status-left"
	update_tmux_window_option "window-status-format"
	update_tmux_window_option "window-status-current-format"
}
main
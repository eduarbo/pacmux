#!/usr/bin/env bash

set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=helpers.sh
source "$CURRENT_DIR/helpers.sh"

pacmux_overview() {
	local i=1
	while IFS= read -r attached; do
		case "$attached" in
			1)
				printf "%s %s" "$(ghost "$i")" "$separator"
				while IFS= read -r wflag; do
					case "$wflag" in
						1) pacman ;;
						2) blue_ghost ;;
						3) printf "#[none]#[%s]%s" "$dots_style" "$pellet_char" ;;
						*) printf "#[none]#[%s]%s" "$dots_style" "$dot_char" ;;
					esac
				done <<< "$(tmux list-windows -F '#{?window_active,1,#{?window_bell_flag,2,#{?window_activity_flag,3,0}}}')"
				printf "%s" "$separator"
				;;
			*)
				printf "%s%s" "$(ghost "$i")" "$separator"
				;;
		esac
		i=$(( i + 1 ))
	done <<< "$(tmux list-sessions -F '#{session_attached}')"
}

pacmux_overview

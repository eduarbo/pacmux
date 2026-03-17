#!/usr/bin/env bash

set -euo pipefail

CURRENT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
# shellcheck source=helpers.sh
source "$CURRENT_DIR/helpers.sh"

pacmux_sessions() {
	local i=1
	while IFS="|" read -r attached name; do
		case "$attached" in
			1) printf "%s %s%s" "$(ghost "$i")" "$name" "$separator" ;;
			*) printf "%s%s" "$(ghost "$i")" "$separator" ;;
		esac
		i=$(( i + 1 ))
	done <<< "$(tmux list-sessions -F '#{session_attached}|#{session_name}')"
}

pacmux_sessions

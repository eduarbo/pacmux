#!/usr/bin/env bash

set_tmux_option() {
	local option="$1"
	local value="$2"
	local flags="${3:-}"
	tmux set-option -gq"$flags" "$option" "$value"
}

set_tmux_window_option() {
	set_tmux_option "$1" "$2" "w"
}

get_tmux_option() {
	local option="$1"
	local default_value="${2:-}"
	local flags="${3:-}"
	local option_value
	option_value="$(tmux show-option -gqv"$flags" "$option" 2>/dev/null)" || true
	if [ -z "$option_value" ]; then
		echo "$default_value"
	else
		echo "$option_value"
	fi
}

get_tmux_window_option() {
	get_tmux_option "$1" "${2:-}" "w"
}

# Style options
blue_ghost_style=$(get_tmux_option "@pacmux-blue-ghost-style" "fg=blue")
pacman_style=$(get_tmux_option "@pacmux-pacman-style" "fg=yellow")
dots_style=$(get_tmux_option "@pacmux-dots-style" "fg=white")

# Character options
pacman_char=$(get_tmux_option "@pacmux-pacman-char" "ᗧ")
pacman_close_char=$(get_tmux_option "@pacmux-pacman-close-char" "ᗤ")
ghost_char=$(get_tmux_option "@pacmux-ghost-char" "ᗣ")
dot_char=$(get_tmux_option "@pacmux-dot-char" "·")
pellet_char=$(get_tmux_option "@pacmux-pellet-char" "•")

# Animation option
animate=$(get_tmux_option "@pacmux-animate" "off")

# Separator option (used by scripts that source this file)
# shellcheck disable=SC2034
separator=$(get_tmux_option "@pacmux-separator" " ")

_anim_file="/tmp/pacmux_anim_$(tmux display-message -p '#{pid}' 2>/dev/null || echo $$)"

_get_pacman_char() {
	if [ "$animate" = "on" ]; then
		if [ -f "$_anim_file" ]; then
			rm -f "$_anim_file"
			printf '%s' "$pacman_close_char"
		else
			touch "$_anim_file"
			printf '%s' "$pacman_char"
		fi
	else
		printf '%s' "$pacman_char"
	fi
}

pacman() {
	local char
	char="$(_get_pacman_char)"
	printf "#[none]#[%s]%s#[default]" "$pacman_style" "$char"
}

blue_ghost() {
	printf "#[none]#[%s]%s #[default]" "$blue_ghost_style" "$ghost_char"
}

window_flag() {
	printf "#[none]#[%s]#{?window_bell_flag,,#[none]#[%s]}#{?window_bell_flag,%s,#{?window_activity_flag,%s,%s}}#[default]" \
		"$blue_ghost_style" "$dots_style" "$ghost_char" "$pellet_char" "$dot_char"
}

window_flag_zoomed() {
	printf "#{?window_zoomed_flag,#[none]#[%s]%s#[default],%s}" \
		"$blue_ghost_style" "$ghost_char" "$(window_flag)"
}

ghost() {
	local idx="${1:-0}"
	local styles
	styles=(
		"$(get_tmux_option "@pacmux-blinky-style" "fg=red")"
		"$(get_tmux_option "@pacmux-pinky-style" "fg=brightmagenta")"
		"$(get_tmux_option "@pacmux-inky-style" "fg=brightcyan")"
		"$(get_tmux_option "@pacmux-clyde-style" "fg=yellow")"
	)
	printf "#[none]#[%s]%s#[default]" "${styles[$(( (idx - 1) % 4 ))]}" "$ghost_char"
}

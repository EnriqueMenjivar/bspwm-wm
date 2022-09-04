#!/usr/bin/env bash

SDIR="$HOME/.config/polybar/scripts"

# Launch Rofi
MENU="$(rofi -no-config -no-lazy-grab -sep "|" -dmenu -i -p '' \
-theme ~/.config/rofi/launchers/type-3/style-5.rasi \
<<< " Default| Nord| Gruvbox| Dark| Cherry|")"
            case "$MENU" in
				*Default) "$SDIR"/set_style.sh --default ;;
				*Nord) "$SDIR"/set_style.sh --nord ;;
				*Gruvbox) "$SDIR"/set_style.sh --gruvbox ;;
				*Dark) "$SDIR"/set_style.sh --dark ;;
				*Cherry) "$SDIR"/set_style.sh --cherry ;;
            esac

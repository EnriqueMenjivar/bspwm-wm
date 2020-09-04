#!/bin/bash

rofi \
    -show window \
    -show-icons \
    -padding 20 \
    -line-padding 4 \
    -theme Arc-Dark \
    -font "Hack Nerd Font Mono 12" \
    -kb-cancel "Super+Escape,Escape" \
    -kb-accept-entry "!Super-Up,!Super-Down,Return"\
    -kb-row-down "Super+Down" \
    -kb-row-up "Super+Up"

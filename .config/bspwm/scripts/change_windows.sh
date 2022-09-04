#!/bin/bash

rofi -show window \
    -show-icons \
    -padding 20 \
    -line-padding 4 \
    -theme ~/.config/rofi/launchers/type-3/style-4.rasi \
    -kb-cancel "Super+Escape,Escape" \
    -kb-accept-entry "!Super-Up,!Super-Down,Return"\
    -kb-row-down "Super+Down" \
    -kb-row-up "Super+Up"

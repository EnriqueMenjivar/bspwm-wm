#!/bin/bash

picom_path=/home/enrique/.config/picom/picom.conf
inactive_opacity=$(grep '^inactive-opacity = ' $picom_path | cut -d ' ' -f3 | tr -d ';')

if [[ $inactive_opacity < 0 ]] && [ $1 == "-" ]; then
    exit 0
fi

if [[ $inactive_opacity > 1 ]] && [ $1 == "+" ]; then
    exit 0
fi

case $1 in
    +)
        inactive=$(python -c "print ($inactive_opacity+0.05)")
        sed -i "/^inactive-opacity = /c\inactive-opacity = $inactive;" $picom_path;;
    -)
        inactive=$(python -c "print ($inactive_opacity-0.05)")
        sed -i "/^inactive-opacity = /c\inactive-opacity = $inactive;" $picom_path;;
    *) exit 0;;
esac

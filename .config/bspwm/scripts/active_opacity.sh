#!/bin/bash

picom_path=/home/enrique/.config/picom/picom.conf
active_opacity=$(grep '^active-opacity' $picom_path | cut -d ' ' -f3 | tr -d ';')
inactive_opacity=$(grep '^inactive-opacity = ' ~/.config/picom/picom.conf | cut -d ' ' -f3 | tr -d ';')

if [[ $active_opacity < 0 ]] && [ $1 == "-" ]; then
    exit 0
fi

if [[ $active_opacity > 1 ]] && [ $1 == "+" ]; then
    exit 0
fi

case $1 in
    +)
      active=$(python -c "print (round($active_opacity+0.05,2))")
        sed -i "/^active-opacity/c\active-opacity = $active;" $picom_path;;
    -)
      active=$(python -c "print (round($active_opacity-0.05,2))")
        sed -i "/^active-opacity/c\active-opacity = $active;" $picom_path;;
    *) exit 0;;
esac

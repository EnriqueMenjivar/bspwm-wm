#!/bin/bash

#Dependencies : mpg123 -> play sounds alert, notify-send -> send notifications, dunst -> servicio para el envío de notificacion

battery_level=$(acpi -b | awk '{print $4}' | tr -d '%,')
battery_state=$(acpi -b | awk '{print $3}' | tr -d ',')
battery_remaining=$(acpi | grep -oh '[0-9:]* remaining' | sed 's/:\w\w remaining$/ Minutes/'  | sed 's/00://' | sed 's/:/h /')

if [ ! -f "/tmp/.battery" ]; then
    echo "$battery_level" > /tmp/.battery
    echo "$battery_state" >> /tmp/.battery
    exit
fi

previous_battery_level=$(cat /tmp/.battery | head -n 1)
previous_battery_state=$(cat /tmp/.battery | tail -n 1)
echo "$battery_level" > /tmp/.battery
echo "$battery_state" >> /tmp/.battery

checkBatteryLevel() {
    if [ $battery_state != "Discharging" ] || [ "${battery_level}" == "${previous_battery_level}" ]; then
        exit 0
    fi

    if [ $battery_level -le 5 ]; then
        sudo systemctl suspend
    elif [ $battery_level -le 10 ]; then
        notify-send "Low Battery" "Your computer will suspend soon unless plugged into a power outlet." -u critical
        mpg123 /home/enrique/.config/bspwm/sounds/low_battery.mp3 > /dev/null 2>&1
    elif [ $battery_level -le 20 ]; then
        notify-send "Low Battery" "${battery_level}% (${battery_remaining}) of battery remaining." -u normal
        mpg123 /home/enrique/.config/bspwm/sounds/low_battery.mp3 > /dev/null 2>&1
    fi
}

checkBatteryStateChange() {
    if [ "$battery_state" != "Discharging" ] && [ "$previous_battery_state" == "Discharging" ]; then
        notify-send "Charging" "Battery is now plugged in." -u low
        mpg123 /home/enrique/.config/bspwm/sounds/plug.mp3 > /dev/null 2>&1
    fi

    if [ "$battery_state" == "Discharging" ] && [ "$previous_battery_state" != "Discharging" ]; then
        notify-send "Power Unplugged" "Your computer has been disconnected from power." -u low
        mpg123 /home/enrique/.config/bspwm/sounds/unplug.mp3 > /dev/null 2>&1
    fi

    if [ "$battery_state" == "Full" ] && [ "${battery_level}" != "${previous_battery_level}" ]; then
    	notify-send "Full" "Battery fully charged." -u low
        mpg123 /home/enrique/.config/bspwm/sounds/full.mp3 > /dev/null 2>&1
    fi
}

checkBatteryStateChange
checkBatteryLevel

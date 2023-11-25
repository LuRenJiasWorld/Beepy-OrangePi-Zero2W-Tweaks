#!/bin/bash
gpio mode 5 in
while true; do
    data=$(gpio read 5)
    if [[ $data -eq 0 ]]; then
        ydotool key ctrl+b
        sleeo 0.2
        ydotool key c
        sleep 1
        ydotool type "~/scripts/archlinux.sh"
        sleep 0.2
        ydotool key enter
    fi
    sleep 1
done

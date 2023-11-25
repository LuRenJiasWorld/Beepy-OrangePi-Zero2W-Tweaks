#!/bin/bash

caffeine_mode="$(cat /tmp/caffeine_mode)"
if [[ $caffeine_mode -eq 1 ]]; then
  exit
fi
previous_power_mode="$(cat /tmp/current_power_mode)"

/home/lurenjiasworld/scripts/set-power-mode.sh 2

tty-clock -B -r &
read -rsn1 -p"Press any key to exit";echo

killall tty-clock
echo "Restore previous power mode"
/home/lurenjiasworld/scripts/set-power-mode.sh $previous_power_mode

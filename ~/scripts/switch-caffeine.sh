#!/bin/bash

if [[ ! -f /tmp/caffeine_mode ]]; then
  echo 0 | tee /tmp/caffeine_mode > /dev/null
fi

current_status=$(cat /tmp/caffeine_mode)

if [[ $current_status -eq 0 ]]; then
  echo 1 | tee /tmp/caffeine_mode
else
  echo 0 | tee /tmp/caffeine_mode
fi

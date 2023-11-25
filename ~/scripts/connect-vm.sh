#!/bin/bash
while true; do
  output=$(ssh lurenjiasworld@127.0.0.1 -p 10122 bash -c uname 2>/dev/null)

  if [[ $output == *"Linux"* ]]; then
    ssh lurenjiasworld@127.0.0.1 -p 10122
    break
  else
    echo "Server not ready, retrying in 2 seconds..."
    sleep 2
  fi
done


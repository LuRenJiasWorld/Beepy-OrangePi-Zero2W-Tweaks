#!/bin/bash
dbm=$(sudo iwconfig | grep -o -E "Signal level=-[0-9]+ dBm" | grep -o -E "\-[0-9]+") 2> /dev/null
if [[ $dbm == "" ]]; then
  echo -n "N/A"
else
  echo $dbm
fi

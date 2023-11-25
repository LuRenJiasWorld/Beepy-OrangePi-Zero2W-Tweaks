#!/bin/bash
echo $(awk '{printf("%d",$1/1000)}' </etc/orangepimonitor/datasources/soctemp)

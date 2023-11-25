#!/bin/bash
set -x
ssh root@127.0.0.1 -p 10122 bash -c "echo 3 \| sudo tee /proc/sys/vm/drop_caches; blockdev --flushbufs /dev/sda; sync; halt"
sudo systemctl stop vm
sudo rm memsnapshot
sudo systemctl start vm

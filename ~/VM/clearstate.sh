#!/bin/bash
set -x
ssh root@127.0.0.1 -p 10122 bash -c "sync; halt"
sudo systemctl stop vm
sudo rm memsnapshot
sudo systemctl start vm

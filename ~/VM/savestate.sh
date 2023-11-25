#!/usr/bin/expect
# https://stackoverflow.com/questions/7013137/automating-telnet-session-using-bash-scripts
# https://serverfault.com/questions/889163/combine-snapshot-and-loadvm-snap-id-in-qemu-system

set timeout 120

spawn telnet 127.0.0.1 45454
expect "(qemu)"
send "migrate \"exec: cat > memsnapshot\"\n"
expect "(qemu)"
send "quit\n"
interact

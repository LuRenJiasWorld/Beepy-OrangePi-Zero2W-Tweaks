#!/bin/bash
eval `dbus-launch --auto-syntax`
fcitx >/dev/null 2>&1
fbterm -i fcitx-fbterm -- tmux attach -t term \; set-option window-size manual \; send-keys "clear; ~/scripts/welcome.sh; cd ~; ~/scripts/archlinux.sh" Enter
kill $DBUS_SESSION_BUS_PID
fcitx-remote -e

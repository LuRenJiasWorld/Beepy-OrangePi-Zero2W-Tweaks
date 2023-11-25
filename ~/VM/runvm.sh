#!/bin/bash
set -x

if [ "$1" == "resume" ] && [ -f memsnapshot ]; then
    resume_args=(-incoming 'exec: cat memsnapshot' -snapshot)
else
    resume_args=()
fi

qemu-system-aarch64 \
    -name "ArchLinux on ARM64" \
    -M virt,highmem=off \
    -accel kvm \
    -cpu cortex-a53 \
    -smp 4 \
    -m 512 \
    -rtc base=utc \
    -no-reboot \
    -monitor telnet::45454,server,nowait -serial mon:stdio \
    -drive file=pflash0.img,format=raw,if=pflash,readonly=on  \
    -drive file=pflash1.img,format=raw,if=pflash \
    -display none -vnc 0.0.0.0:0 \
    -device virtio-gpu-pci \
    -device nec-usb-xhci \
    -device usb-kbd \
    -device usb-tablet \
    -device virtio-balloon-pci \
    -nic user,model=virtio-net-pci,hostfwd=tcp::10122-:22 \
    -device virtio-scsi-pci,id=scsi \
    -device scsi-hd,drive=boot,serial=boot \
    -drive file="/home/lurenjiasworld/VM/Disks/ArchLinuxArm_fresh_installed.qcow2",if=none,id=boot \
    -device usb-storage,drive=cdrom0,serial=cdrom0 \
    -drive file="",media=cdrom,if=none,id=cdrom0 "${resume_args[@]}" &


while true; do
    output=$(ssh lurenjiasworld@127.0.0.1 -p 10122 bash -c uname 2>/dev/null)

    if [[ $output == *"Linux"* ]]; then
        echo "Server ready, remove snapshot file"
        rm -f memsnapshot
        break
    else
        echo "Server not ready, retrying in 2 seconds..."
        sleep 2
    fi
done
wait

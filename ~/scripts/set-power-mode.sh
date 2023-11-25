#!/bin/bash
# 设置电源策略
# - 0: 默认电源策略 CPU 频率范围:  480MHz-1200MHz, 调度器: conservative, 开启所有核心,    键盘灯光设置为 64
# - 1: 节能模式     CPU 频率范围： 480MHz-1200MHz, 调度器: conservative, 只开启 2 个核心, 键盘灯光设置为 24
# - 2: 节能模式+    CPU 频率范围:  480MHz-480MHz , 调度器: powersave   , 只开启 1 个核心, 键盘灯光设置为 0
# - 3: 性能模式     CPU 频率范围:  600MHz-1512MHz, 调度器: ondemand    , 开启所有核心,    键盘灯光设置为 96
# - 4: 性能模式+    CPU 频率范围: 1512MHz-1512MHz, 调度器: performance , 开启所有核心,    键盘灯光设置为 200
power_mode=${1:-"0"}

# 记录当前电源策略
echo $power_mode | tee /tmp/current_power_mode > /dev/null

case $1 in
    0)
        # 设置默认电源策略
        echo "设置默认电源策略"
        # 开启所有核心
        echo 1 | sudo tee /sys/devices/system/cpu/cpu0/online > /dev/null
        echo 1 | sudo tee /sys/devices/system/cpu/cpu1/online > /dev/null
        echo 1 | sudo tee /sys/devices/system/cpu/cpu2/online > /dev/null
        echo 1 | sudo tee /sys/devices/system/cpu/cpu3/online > /dev/null
        # 设置 CPU 频率范围:  480MHz-1512MHz
        echo 480000       | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq > /dev/null
        echo 1200000      | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq > /dev/null
        # 设置调度器: conservative
        echo conservative | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor > /dev/null
        echo 1            | sudo tee /sys/devices/system/cpu/cpufreq/conservative/ignore_nice_load > /dev/null
        echo 4            | sudo tee /sys/devices/system/cpu/cpufreq/conservative/freq_step > /dev/null
        echo 40           | sudo tee /sys/devices/system/cpu/cpufreq/conservative/down_threshold > /dev/null
        echo 2            | sudo tee /sys/devices/system/cpu/cpufreq/conservative/sampling_down_factor > /dev/null
        # 设置键盘灯光
        echo 64           | sudo tee /sys/firmware/beepy/keyboard_backlight > /dev/null
        ;;
    1)
        # 设置节能模式
        echo "设置节能模式"
        # 只开启 2 个核心
        echo 1 | sudo tee /sys/devices/system/cpu/cpu0/online > /dev/null
        echo 1 | sudo tee /sys/devices/system/cpu/cpu1/online > /dev/null
        echo 0 | sudo tee /sys/devices/system/cpu/cpu2/online > /dev/null
        echo 0 | sudo tee /sys/devices/system/cpu/cpu3/online > /dev/null
        # 设置 CPU 频率范围： 480MHz-1200MHz
        echo 480000       | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq > /dev/null
        echo 1200000      | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq > /dev/null
        # 设置调度器: conservative
        echo conservative | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor > /dev/null
        echo 1            | sudo tee /sys/devices/system/cpu/cpufreq/conservative/ignore_nice_load > /dev/null
        echo 2            | sudo tee /sys/devices/system/cpu/cpufreq/conservative/freq_step > /dev/null
        echo 60           | sudo tee /sys/devices/system/cpu/cpufreq/conservative/down_threshold > /dev/null
        echo 1            | sudo tee /sys/devices/system/cpu/cpufreq/conservative/sampling_down_factor > /dev/null
        # 设置键盘灯光
        echo 24           | sudo tee /sys/firmware/beepy/keyboard_backlight > /dev/null
        ;;
    2)
        # 设置节能模式+
        echo "设置节能模式+"
        # 只开启 1 个核心
        echo 1 | sudo tee /sys/devices/system/cpu/cpu0/online > /dev/null
        echo 0 | sudo tee /sys/devices/system/cpu/cpu1/online > /dev/null
        echo 0 | sudo tee /sys/devices/system/cpu/cpu2/online > /dev/null
        echo 0 | sudo tee /sys/devices/system/cpu/cpu3/online > /dev/null
        # 设置 CPU 频率范围:  480MHz-480MHz
        echo 480000    | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq > /dev/null
        echo 480000    | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq > /dev/null
        # 设置调度器: powersave
        echo powersave | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor > /dev/null
        # 设置键盘灯光
        echo 0           | sudo tee /sys/firmware/beepy/keyboard_backlight > /dev/null
        ;;
    3)
        # 设置性能模式
        echo "设置性能模式"
        # 开启所有核心
        echo 1 | sudo tee /sys/devices/system/cpu/cpu0/online > /dev/null
        echo 1 | sudo tee /sys/devices/system/cpu/cpu1/online > /dev/null
        echo 1 | sudo tee /sys/devices/system/cpu/cpu2/online > /dev/null
        echo 1 | sudo tee /sys/devices/system/cpu/cpu3/online > /dev/null
        # 设置 CPU 频率范围:  600MHz-1512MHz
        echo 600000       | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq > /dev/null
        echo 1512000      | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq > /dev/null
        # 设置调度器: ondemand
        echo ondemand     | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor > /dev/null
        echo 0            | sudo tee /sys/devices/system/cpu/cpufreq/ondemand/ignore_nice_load > /dev/null
        echo 10           | sudo tee /sys/devices/system/cpu/cpufreq/ondemand/up_threshold > /dev/null
        echo 20           | sudo tee /sys/devices/system/cpu/cpufreq/ondemand/sampling_down_factor > /dev/null
        # 设置键盘灯光
        echo 96           | sudo tee /sys/firmware/beepy/keyboard_backlight > /dev/null
        ;;
    4)
        # 设置性能模式+
        echo "设置性能模式+"
        # 开启所有核心
        echo 1 | sudo tee /sys/devices/system/cpu/cpu0/online > /dev/null
        echo 1 | sudo tee /sys/devices/system/cpu/cpu1/online > /dev/null
        echo 1 | sudo tee /sys/devices/system/cpu/cpu2/online > /dev/null
        echo 1 | sudo tee /sys/devices/system/cpu/cpu3/online > /dev/null
        # 设置 CPU 频率范围: 1512MHz-1512MHz
        echo 1512000      | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq > /dev/null
        echo 1512000      | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq > /dev/null
        # 设置调度器: performance
        echo performance  | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor > /dev/null
        # 设置键盘灯光
        echo 200          | sudo tee /sys/firmware/beepy/keyboard_backlight > /dev/null
        ;;
    *)
        echo "参数错误"
        ;;
esac

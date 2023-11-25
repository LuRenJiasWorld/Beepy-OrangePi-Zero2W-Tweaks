# Beepy OrangePi Zero2W Tweaks


> [Beepy](https://beepy.sqfmi.com/) 是由 [SQFMI](https://sqfmi.com/) 基于 [BBQ20KBD](https://www.solder.party/docs/bbq20kbd/) 项目开发的开源硬件，官方使用树莓派 Zero 作为核心板，但由于树莓派Zero的性能较弱，且性价比低，有闲鱼玩家开发了支持香橙派 Zero 2W 的驱动，并以较高的性价比销售 DIY 套件。本文将以该套件和香橙派 Zero 2W 为基础，分享一些笔者的个人配置，并尽量使其更实用、更美观、更高效

<p align="center">
    <img src="https://github.com/LuRenJiasWorld/Beepy-OrangePi-Zero2W-Tweaks/blob/master/.pic/Beepy1.jpg" alt="Beepy演示图片1" height="360"/>
    <img src="https://github.com/LuRenJiasWorld/Beepy-OrangePi-Zero2W-Tweaks/blob/master/.pic/Beepy2.jpg" alt="Beepy演示图片2" height="360"/>
</p>

> 声明：
> 1. 以下内容假定你有一定的 Linux 基础，最好是使用过树莓派、香橙派等开发板。
> 2. 不一定需要进行所有操作，可以选你喜欢的进行修改。
> 3. 在进行任何操作之前**请备份**！最好的备份方式就是在折腾期间使用一个小容量（如8G）内存卡，然后在进行关键操作之前使用 `dd` 命令进行备份。
> 4. 文章里提到的所有脚本都可以在 [GitHub仓库](https://github.com/LuRenJiasWorld/Beepy-OrangePi-Zero2W-Tweaks) 里找到并下载，仓库里的脚本是我个人使用的脚本，你需要根据你的用户名、配置进行修改。
> 5. 如果文章里的脚本和脚本文件不一致，以脚本为准，脚本是我个人真正验证并使用过的，里面还有一些文章里没有提到的脚本，可自取使用，
> 6. 仓库 `.resources` 目录里包含一些下文可能会用到的资源，由于缺乏官方链接，无法链接引用，仅用作分享，版权归原作者所有。
> 7. 相关参考链接可在文末找到，可以借助参考链接进一步理解项目，发掘更多的玩法。

- [Beepy OrangePi Zero2W Tweaks](#beepy-orangepi-zero2w-tweaks)
  - [安装](#安装)
  - [设置键盘和屏幕](#设置键盘和屏幕)
  - [修改用户名和 home 目录](#修改用户名和-home-目录)
  - [加快开机速度](#加快开机速度)
  - [使用 ntpdate 代替 chrony](#使用-ntpdate-代替-chrony)
  - [键盘键位映射](#键盘键位映射)
  - [去掉启动时的 last login 提示](#去掉启动时的-last-login-提示)
  - [终端字体设置](#终端字体设置)
  - [USB0 设置为 Host](#usb0-设置为-host)
  - [设置更大的 ZRAM](#设置更大的-zram)
  - [提升 ZRAM 性能](#提升-zram-性能)
  - [避免断电导致数据丢失](#避免断电导致数据丢失)
  - [避免 Core Dump](#避免-core-dump)
  - [配置 zsh，并对单色显示器进行优化](#配置-zsh并对单色显示器进行优化)
  - [使用 fbterm 支持中文显示](#使用-fbterm-支持中文显示)
  - [使用 fbterm 和 fcitx 支持中文输入](#使用-fbterm-和-fcitx-支持中文输入)
  - [使用 tmux 实现多窗口](#使用-tmux-实现多窗口)
  - [使用 tmux 实现比显示区域更大的窗口](#使用-tmux-实现比显示区域更大的窗口)
  - [支持虚拟机，变相实现休眠](#支持虚拟机变相实现休眠)
  - [实现侧边按键绑定](#实现侧边按键绑定)
  - [省电模式和性能模式预设](#省电模式和性能模式预设)
  - [实现屏幕保护程序（时钟）](#实现屏幕保护程序时钟)
  - [相关资料](#相关资料)


## 安装
- 下载镜像，或者从源码编译：http://www.orangepi.cn/orangepiwiki/index.php/Orange_Pi_Zero_2W
    - 编译源码可以使用按小时计费的服务器，4 核大概在 90 分钟左右，耗费成本 0.7 元
    - 编译的时候可以在菜单里启用 KVM 选项，后续可以用这个变通实现休眠功能
- 在没有 Mini HDMI 线的情况下，可以配置开机自动连接 wifi，参考 `/boot/orangepi_first_run.txt.template`，修改里面的内容并重命名
- 首次开机需要大概 5 分钟，期间会对 SD 卡进行扩容
- 使用 ssh 连接到机器，账号密码均为 `orangepi`
- 更新系统 `sudo apt update && sudo apt upgrade`

## 设置键盘和屏幕
- 将键盘和屏幕的驱动拷贝到 Pi 上
- 安装 Linux headers: `sudo dpkg -i /opt/linux-headers*`
- 安装键盘驱动
    - 设置 overlay `sudo orangepi-add-overlay beepy-kbd.dts`
    - 编译内核模块 `make all -j 4`
    - 拷贝内核模块到 modules 文件夹 `sudo cp beppy-kbd.ko /lib/modules/*-sun50iw9/`
    - 设置开机加载内核 `echo beepy-kbd | sudo tee -a /etc/modules`
    - 拷贝并应用键盘映射
        - `mkdir -p /usr/share/kbd/keymaps`
        - `sudo cp beepy-kbd.map /usr/share/kbd/keymaps`
        - `sudo rm -f /etc/console-setup/cached_setup_keyboard.sh`
        - `echo KMAP=/usr/share/kbd/keymaps/beepy-kbd.map | sudo tee -a /etc/default/keyboard`
- 安装屏幕驱动（推荐带 dither 的版本）
    - 设置 overlay `sudo orangepi-add-overlay sharp-drm.dts`
    - 编译内核模块 `make all -j 4`
    - 拷贝内核模块到 modules 文件夹 `sudo cp sharp-drm.ko /lib/modules/*-sun50iw9/`
    - 设置开机加载内核 `echo sharp-drm | sudo tee -a /etc/modules`
- 重新加载内核 `sudo depmod -a`
- 重启 beepy

## 修改用户名和 home 目录
- 修改 root 密码 `sudo su` `passwd`
- 使用 SSH 登录到 root
- `cp -r /home/orangepi /home/<新用户名>`
- 编辑 `/usr/lib/systemd/system/getty@.service.d/override.conf` 和 `/usr/lib/systemd/system/serial-getty@.service.d/override.conf`, 将用户名改为 root
- 重启之后，执行 `usermod -l <新用户名> -d /home/<新用户名> orangepi`
- 重新编辑 `/usr/lib/systemd/system/getty@.service.d/override.conf` 和 `/usr/lib/systemd/system/serial-getty@.service.d/override.conf`，将用户名修改为 `<新用户名>`
- 重启之后，查看当前用户名 `id` 和当前家目录 `pwd` 是否修改成功
- 删除旧的家目录 `sudo rm -rf /home/orangepi`

## 加快开机速度
- 编辑 `/usr/lib/systemd/system/getty@.service.d/override.conf`，去掉里面的 `ExecStartPre`
- 使用 `sudo systemd-analyze blame` 分析出耗时长的服务，并使用 `sudo systenctl disable` 禁用掉不需要的服务
- 使用 `sudo systemd-analyze critical-chain` 分析出阻塞的服务
- 禁用 `orangepi-ramlog.service` 可以有效提升启动时间，但会导致 SD 卡寿命下降，可以使用工业卡（最好是 MLC 的）来避免这个问题，并保持多备份的习惯

## 使用 ntpdate 代替 chrony
> chrony 无法处理时间突变，会导致时间很慢才能正常同步
- 设置正确的时区 `sudo timedatectl set-timezone Asia/Shanghai`
- 卸载 chrony `sudo apt remove chrony`
- 设置正确的时间，避免 `apt` 出错 `sudo timedatectl set-time '2023-11-24 16:14:50'`
- 安装 ntpdate `sudo apt update && sudo apt install ntpdate`
- 在开机脚本里同步时间，编辑 `/etc/rc.local`，加入 `sudo -u <用户名> screen -h 32768 -dmS ntp bash -c 'sleep 30; while true; do date; sudo ntpdate -d 203.107.6.88 182.92.12.11 114.118.7.161 114.118.7.163; sleep 60; done;'`，这样每 60 秒就会同步一次时间
    - 这里使用的是阿里云和国家授时中心的 NTP 服务器地址，直接使用 IP 地址，避免解析出错导致无法成功更新时间
- 时间正确之后，可以更新一次系统 `sudo apt update && sudo apt upgrade`

## 键盘键位映射
- Beepy 默认的键位不太直观：https://beepy.sqfmi.com/docs/firmware/keyboard ，ctrl 键在左上角，Shift 键在普通键盘 Ctrl 键的位置，Alt 键在普通键盘 Shift 键的位置
- 可以编辑 `src/input_iface.c`，修改 `report_key_input_event` 函数里对修饰键的处理，映射如下：
    - `sticky_shift` -> `sticky_ctrl`
    - `sticky_phys_alt` -> `sticky_shift`
    - `sticky_altgr` -> `sticky_phys_alt`
    - `sticky_ctrl` -> `sticky_altgr`
- 重新编译安装键盘驱动，重启生效

## 去掉启动时的 last login 提示
> 屏幕比较小，这个提示一定会换行，非常难看，也没有意义
- 编辑 `/etc/pam.d/login`，在 `pam_lastlog.so` 之后加上 `silent`

## 终端字体设置
> 启动日志里的方块其实是省略号，但显示不出来就很难看，而且字体太大，可以设置小一些
- 编辑 `/etc/default/console-setup`，设置 `FONTSIZE=6x12`，添加一行 `FONT="Uni3-Terminus12x6.psf.gz"`
- `sudo setupcon` 立即生效，或者重启后生效

## USB0 设置为 Host
> 默认只有 USB1 是可以作为 OTG 的，但是我们的 Beepy 电源来自 GPIO，所以可以把 USB0 也设置为 OTG 模式
- `sudo cp /boot/dtb/allwinner/overlay/sun50i-h616-usb0-host.dtbo /boot/overlay-user/`
- `user_overlays` 加入 `sun50i-h616-usb0-host`
- 重启生效
> 如果要关闭状态 LED 灯（闪烁的绿灯），使用类似方法加入 `sun50i-h616-zero2w-disable-led` 即可

## 设置更大的 ZRAM
> 默认的 ZRAM 大小是内存的一半，而且压缩算法也不是更先进的 zstd 算法
- 编辑 `sudo vim /etc/default/orangepi-zram-config`，修改 `ZRAM_PERCENTAGE=100`，`SWAP_ALGORITHM=zstd`
- 重启生效

## 提升 ZRAM 性能
> 默认的 Swap 策略是给磁盘设计的，不适用于内存
- 修改 `/etc/sysctl.conf`
```ini
vm.swappiness = 85
vm.vfs_cache_pressure = 400
vm.page-cluster = 0
```

## 避免断电导致数据丢失
> 尽量让数据更早写入 SD 卡，而不是缓冲满了之后才写入
- 修改 `/etc/sysctl.conf`
```ini
# https://lonesysadmin.net/2013/12/22/better-linux-disk-caching-performance-vm-dirty_ratio/
vm.dirty_background_ratio = 4
vm.dirty_ratio = 8
vm.dirty_expire_centisecs = 2000
vm.dirty_writeback_centisecs = 1000
```

## 避免 Core Dump
> 频繁的 Core Dump 会导致 SD 卡写入大量文件，影响寿命，占用空间
- 修改 `/etc/sysctl.conf`
```ini
fs.suid_dumpable=0
kernel.core_pattern=|/bin/false
```

## 配置 zsh，并对单色显示器进行优化
- 安装 zsh `sudo apt install zsh`
- 使用 oh-my-zsh `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`，将 zsh 设置为默认 shell
- 修改 `~/.zshrc`，最后一行加入 `export PROMPT="%c | # "`
- 修改`~/.zshrc`，最后一行加入 `export TERM=xterm-mono`
- 修改 `/etc/environment`，加入 `TERM=xterm-mono`
- 重启后，检查 prompt 是否变成 `~ | #`

## 使用 fbterm 支持中文显示
- 安装中文字体，这里以 Zpix Mono（7px 像素字体，支持中英文，且中英文等宽）为例
- 拷贝字体到 `/usr/local/share/fonts/truetype/` （没有文件夹则自己新建一个）
- 安装 `fontconfig` 包 `sudo apt install fontconfig`
- 刷新字体缓存 `sudo fc-cache -fv`
- 安装 `fbterm` `sudo apt install fbterm`
- 编辑 `~/.fbtermrc`
```ini
font-names=Zpix Mono
font-size=12
font-width=7
term=xterm-mono
text-encodings=utf-8
```
- 运行 `fbterm`，查看字体是否正常

## 使用 fbterm 和 fcitx 支持中文输入
- 安装依赖
    - 安装 `dbus` `sudo apt install qdbus dbus-x11`
    - 安装桌面环境：`sudo apt install xfce4`
    - 安装 tigervnc：`sudo apt install tigervnc-standalone-server tigervnc-common tightvncserver`
    - 安装 fcitx：`sudo apt install fcitx fcitx-config-gtk fcitx-module-dbus gpm fcitx-frontend-fbterm fcitx-googlepinyin`
- 配置 VNC:
    - 设置 VNC 密码 `vncpasswd`
    - 设置 `~/.vnc/config`
    ```ini
    geometry=1600x900
    localhost=no
    CompareFB=1
    ZlibLevel=5
    FrameRate=30
    alwaysshared
    ```
    - 设置 `/etc/tigervnc/vncserver.users`，加入 `<用户名> :0`
    - 运行 VNC 服务器 `/usr/bin/vncserver -localhost no :0`
    - 在外部 VNC 客户端连接 `<Pi 的 IP 地址>:5900`，输入密码
- 配置输入法
    - 在 Xfce 里打开终端，输入 `fcitx`，挂着不要关
    - 找到 `Application -> Settings -> Fcitx Configuration`，确保第一项是 `Keyboard`，第二项是 `Google Pinyin`，在 Global Config 里确认 Trigger Input Method 为 Ctrl+Space
- 编辑 `~/.fbtermrc`，最后一行加入
    ```ini
    input-method=fcitx-fbterm
    ```
- 设置启动脚本：`~/scripts/fbterm.sh`
    ```bash
    #!/bin/bash
    eval `dbus-launch --auto-syntax`
    fcitx >/dev/null 2>&1
    fbterm -i fcitx-fbterm
    kill $DBUS_SESSION_BUS_PID
    fcitx-remote -e
    ```
- 设置必需的权限：
  - `sudo setcap 'cap_sys_tty_config+ep' /usr/bin/fbterm`
  - `sudo gpasswd -a <用户名> video`
- 执行脚本，在打开的 fbterm 里按下 Ctrl+Space，按几个键，看看是否成功唤起输入法候选框
- 在 tty 里使用 `tput cols` 获取 tty 列数，假设为 66
- 编辑 `~/.zshrc` 或 `~/.bashrc`，在最后加入如下代码：
```bash
if [[ $(tput cols) -eq 66 ]]; then
    echo "Bringing you into fbterm, please wait..."
    # 如果没有用 zsh 的 antigen，则无须这个 while 判断
    while [[ -f ~/.antigen/.lock ]]; do
        sleep 0.2
    done
    sleep 1
    exec ~/scripts/fbterm.sh
fi
```
- 重启 Pi，检查是否会自动进入 fbterm

## 使用 tmux 实现多窗口
- 在 `/etc/rc-local` 里新建一个 session `sudo -u <用户名> screen -h 32768 -dmS term bash -c 'tmux new -s term'`
- 在 `~/scripts/fbterm.sh` 里修改 `fbterm` 启动脚本：`fbterm -i fcitx-fbterm -- tmux attach -t term \; send-keys "clear; cd ~" Enter`
- 重启 Pi，检查是否会自动加入名为 `term` 的 session，并且当前的目录为 `~`

## 使用 tmux 实现比显示区域更大的窗口
> 思路：使用 `xterm` 开一个大窗口，并在这个窗口里启动 `tmux` 会话，然后 attach 到这个 session，并设置不根据当前显示器大小调节 tmux 窗口大小
- 安装 `xvfb`：`sudo apt install xvfb`
- 修改 `/etc/rc.local` 里的 tmux 启动脚本：`sudo -u <用户名> screen -h 32768 -dmS term bash -c 'sleep 1; xvfb-run --server-args="-screen 0, 640x480x8" -a -w 2 xterm -fa "Zpix Mono" -fs 8 -geometry 110x19 -e "tmux new -s term"'`，为了更好的体验，`-geometry` 的行数最好和 `fbterm` 里的行数一致，列数最好是 `fbterm` 里的`（列数* 2)-3`，这样在左右分屏的时候，可以留一两列用于观察旁边的屏幕，更灵活
- 修改 `~/scripts/fbterm.sh` 里的 `fbterm` 启动脚本：`fbterm -i fcitx-fbterm -- tmux attach -t term \; set-option window-size manual \; send-keys "clear; cd ~" Enter`
- 重启 Pi，在 tmux 会话里输入 `tput cols` 和 `tput lines`，查看当前行列数是否比屏幕实际行列数更大
- 使用 `C-b [` 进入复制模式，然后按方向键来移动视口（Viewport），从而查看屏幕内的所有内容

## 支持虚拟机，变相实现休眠
> 各种 Pi 一般都不支持省电模式或者休眠，但频繁开关机也会导致 Session 很难恢复
> 最好的办法就是跑一个虚拟机，关机的时候 save state，开机的时候 load state
- 前置准备
    - 最好是编译一个带 kvm 的镜像，然后检查 `/dev/kvm` 是否存在
    - 自行编译的镜像和官方发行版仓库的内核不兼容，需要屏蔽仓库的版本：`sudo apt-mark hold linux-dtb-next-sun50iw9 linux-headers-next-sun50iw9 linux-image-next-sun50iw9 linux-libc-dev linux-u-boot-orangepizero2w-next`，后续要更新，直接重新编译内核，然后使用 `deb` 包覆盖安装
    - 安装 `qemu`：`sudo apt install qemu-system-arm qemu-utils qemu-system-gui ipxe-qemu qemu-efi-aarch64 qemu-efi seabios`
- 虚拟机部署
    - 拷贝一份 EFI 固件：
    ```bash
    dd if=/dev/zero of=pflash0.img bs=1M count=64 conv=sync
    dd if=/dev/zero of=pflash1.img bs=1M count=64 conv=sync
    dd if=/usr/share/qemu-efi-aarch64/QEMU_EFI.fd of=pflash0.img conv=notrunc,sync
    dd if=/usr/share/AAVMF/AAVMF_VARS.fd of=pflash1.img conv=notrunc,sync
    qemu-img convert -f raw -O qcow2 -o preallocation=full ./pflash1.img ./pflash1.qcow2
    rm pflash1.img
    ```
    - 建立一个硬盘镜像：`qemu-img create -f qcow2 ~/VM/Disks/disk1.qcow2 64G`
    - 设置启动脚本 `~/VM/runvm.sh`：
    ```bash
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
        -drive file=pflash1.qcow2,format=qcow2,if=pflash \
        -display none -vnc 0.0.0.0:0 \
        -device virtio-gpu-pci \
        -device nec-usb-xhci \
        -device usb-kbd \
        -device usb-tablet \
        -device virtio-balloon-pci \
        -nic user,model=virtio-net-pci,hostfwd=tcp::10122-:22 \
        -device virtio-scsi-pci,id=scsi \
        -device scsi-hd,drive=boot,serial=boot \
        -drive file="/home/<用户名>/VM/Disks/disk1.qcow2",if=none,id=boot \
        -device usb-storage,drive=cdrom0,serial=cdrom0 \
        -drive file="",media=cdrom,if=none,id=cdrom0 "${resume_args[@]}" &

    while true; do
        output=$(ssh <用户名>@127.0.0.1 -p 10122 bash -c uname 2>/dev/null)

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
    ```
    - 启动 VNC，使用电脑登录上去，在终端里执行启动脚本，在 `TianoCore` 的加载页面按 ESC，进入 BIOS 设置页面，设置启动项为光盘优先，重启之后安装系统
    - 系统安装完毕后，重新进入 BIOS 设置页面，设置启动项为硬盘优先
    - 安装完毕，并且确保 ssh（上文映射出的 10122 端口）通畅之后，关闭 VNC，修改脚本里的 `-display gtk` 为 `-vnc 0.0.0.0:0`，这样后续可以直接使用 Qemu 的 VNC 维护虚拟机，无须打开桌面环境
- 开机自动运行虚拟机，关机前自动保存状态
    - 安装需要的依赖 `sudo apt install telnet`
    - 写一个脚本 `~/VM/savestate.sh`:
    ```bash
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
    ```
    - 写一个 Systemd 服务 `/etc/systemd/system/vm.service`
    ```ini
    [Unit]
    Description=Run VM
    Requires=rc-local.service
    Before=shutdown.target reboot.target halt.target
    RequiresMountsFor=/

    [Service]
    Type=simple
    ExecStart=/home/<用户名>/VM/runarch.sh resume
    ExecStop=/home/<用户名>/VM/savestate.sh
    WorkingDirectory=/home/<用户名>/VM

    [Install]
    WantedBy=multi-user.target
    ```
    - `sudo systemctl daemon-reload` `sudo systemctl enable vm` 启用服务
    - 重启一次检查是否成功开启虚拟机
    - 再重启一次检查是否能正常恢复状态，并生成对应的 `memsnapshot` 文件，且在确认成功启动之后自动删除这个文件（避免意外关机导致下次开机恢复到与磁盘不一致的状态）
- 开机时自动连接虚拟机
    - `ssh-copy-id` 拷贝公钥
    - 写一个脚本 `~/scripts/connect-vm.sh`:
    ```bash
    #!/bin/bash
    while true; do
        output=$(ssh <用户名>@127.0.0.1 -p 10122 bash -c uname 2>/dev/null)

        if [[ $output == *"Linux"* ]]; then
            ssh <用户名>@127.0.0.1 -p 10122
            break
        else
            echo "Server not ready, retrying in 2 seconds..."
            sleep 2
        fi
    done
    ```
    - 修改 `~/scripts/fbterm.sh` 里的 `fbterm` 启动脚本：`fbterm -i fcitx-fbterm -- tmux attach -t term \; set-option window-size manual \; send-keys "clear; cd ~; ~/scripts/run-vm.sh" Enter`
- 需要重启虚拟机时
    - 写一个脚本 `~/VM/clearstate.sh`：
    ```bash
    #!/bin/bash
    set -x
    ssh root@127.0.0.1 -p 10122 bash -c "sync; halt"
    sudo systemctl stop vm
    sudo rm memsnapshot
    sudo systemctl start vm
    ```

## 实现侧边按键绑定
> 侧边按键绑定在了树莓派的 GPIO 17 上，对应香橙派 Zero2W 是 GPIO 5
> 这里的示例为按下侧边按键，执行特定键盘输入
- 安装 wiringOP：`https://github.com/orangepi-xunlong/wiringOP`
- 安装 ydotool: `sudo apt install ydotool`
- 编写如下脚本 `~/scripts/sidebutton.sh`：
```bash
#!/bin/bash
gpio mode 5 in
while true; do
    data=$(gpio read 5)
    if [[ $data -eq 0 ]]; then
        ydotool key ctrl+b
        sleeo 0.2
        ydotool key c
        sleep 1
        ydotool type "~/scripts/connect-vm.sh"
        sleep 0.2
        ydotool key enter
    fi
    sleep 1
done
```
- 在 `/etc/rc.local` 中加入以下启动脚本：`sudo -u root screen -h 32768 -dmS sidebutton bash -c '~/scripts/sidebutton.sh'`
- 重启 Pi，按下侧边按键，看看是否能在 `tmux` 里新增一个窗口，并运行 `~/script/connect-vm.sh` 脚本

## 省电模式和性能模式预设
- 编写如下脚本 `~/scripts/set-power-mode.sh`:
```bash
#!/bin/bash
# 设置电源策略
# - 0: 默认电源策略 CPU 频率范围：480MHz-1200MHz, 调度器：conservative, 开启所有核心，键盘灯光设置为 64
# - 1: 节能模式     CPU 频率范围： 480MHz-1200MHz, 调度器：conservative, 只开启 2 个核心，键盘灯光设置为 24
# - 2: 节能模式+    CPU 频率范围：480MHz-480MHz , 调度器：powersave   , 只开启 1 个核心，键盘灯光设置为 0
# - 3: 性能模式     CPU 频率范围：600MHz-1512MHz, 调度器：ondemand    , 开启所有核心，键盘灯光设置为 96
# - 4: 性能模式+    CPU 频率范围：1512MHz-1512MHz, 调度器：performance , 开启所有核心，键盘灯光设置为 200
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
        # 设置 CPU 频率范围：480MHz-1512MHz
        echo 480000       | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq > /dev/null
        echo 1200000      | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq > /dev/null
        # 设置调度器：conservative
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
        # 设置调度器：conservative
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
        # 设置 CPU 频率范围：480MHz-480MHz
        echo 480000    | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq > /dev/null
        echo 480000    | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq > /dev/null
        # 设置调度器：powersave
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
        # 设置 CPU 频率范围：600MHz-1512MHz
        echo 600000       | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq > /dev/null
        echo 1512000      | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq > /dev/null
        # 设置调度器：ondemand
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
        # 设置 CPU 频率范围：1512MHz-1512MHz
        echo 1512000      | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_min_freq > /dev/null
        echo 1512000      | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_max_freq > /dev/null
        # 设置调度器：performance
        echo performance  | sudo tee /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor > /dev/null
        # 设置键盘灯光
        echo 200          | sudo tee /sys/firmware/beepy/keyboard_backlight > /dev/null
        ;;
    *)
        echo "参数错误"
        ;;
esac
```
- 在 `/etc/rc.local` 中加入以下启动脚本：`sudo -u <用户名> /home/<用户名>/scripts/set-power-mode.sh 0 > /dev/null`
- 重启后 `cat /tmp/current_power_mode` 查看是否生效

## 实现屏幕保护程序（时钟）
- 使用 `/tmp/caffeine_mode` 控制屏保的开启和关闭
- 安装 `ttyclock` `sudo apt install ttyclock`
- 在 `/etc/rc.local` 中加入以下启动脚本：`echo 0 | sudo -u <用户名> tee /tmp/caffeine_mode > /dev/null`
- 编写 `~/script/screensaver.sh`：
```bash
#!/bin/bash

caffeine_mode="$(cat /tmp/caffeine_mode)"
if [[ $caffeine_mode -eq 1 ]]; then
    exit
fi
previous_power_mode="$(cat /tmp/current_power_mode)"

/home/<用户名>/scripts/set-power-mode.sh 2

tty-clock -B -r &
read -rsn1 -p"Press any key to exit";echo

killall tty-clock
echo "Restore previous power mode"
/home/<用户名>/scripts/set-power-mode.sh $previous_power_mode
```
- 在 `~/.tmux.conf` 里加入如下内容：
```ini
set -g lock-command "/home/<用户名>/scripts/screensaver.sh"
set -g lock-after-time 300
```
- 编写 `~/script/switch-caffeine.sh`
```bash
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
```
- 重启之后，检查 5 分钟后有没有成功进入屏幕保护程序，按任何按键退出屏幕保护程序
- 如果不希望进入屏幕保护程序，则运行 `~/scripts/switch-caffeine.sh` 屏蔽屏幕保护程序

---

## 相关资料
- 官方网站：[https://beepy.sqfmi.com/](https://beepy.sqfmi.com/)
- 官方文档：[https://beepy.sqfmi.com/docs/getting-started](https://beepy.sqfmi.com/docs/getting-started)
- 官方 Discord 频道：[https://discord.gg/AamZusQ4ss](https://discord.gg/AamZusQ4ss)
- 官方开源硬件 GitHub：[https://github.com/sqfmi/beepy-hardware](https://github.com/sqfmi/beepy-hardware)
- 似乎是国人撰写的一篇 Beepy + Tmux + fbterm + fcitx 部署教程：[https://github.com/youngoris/beepy-tmux](https://github.com/youngoris/beepy-tmux)
- 香橙派 Zero 2W 官方文档：[http://www.orangepi.cn/orangepiwiki/index.php/Orange_Pi_Zero_2W](http://www.orangepi.cn/orangepiwiki/index.php/Orange_Pi_Zero_2W)

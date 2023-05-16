#!/bin/bash

## 配置Ubuntu 22.04源

# 定义软件源变量
mirror_url="http://mirrors.tuna.tsinghua.edu.cn/ubuntu/"

# 备份原始的源列表文件
sudo cp /etc/apt/sources.list /etc/apt/sources.list.bak

# 编辑源列表文件
sudo tee /etc/apt/sources.list > /dev/null <<EOF
deb $mirror_url jammy main restricted universe multiverse
deb $mirror_url jammy-updates main restricted universe multiverse
deb $mirror_url jammy-backports main restricted universe multiverse
deb $mirror_url jammy-security main restricted universe multiverse
EOF

# 更新软件包列表
sudo apt update

echo -e "\033[32m软件源已成功配置为 $mirror_url for Ubuntu 22.04 Jammy! \033[0m"

## 设置时区

sudo timedatectl set-timezone Asia/Shanghai

timedatectl status

echo -e "\033[32m设置时区为 Asia/Shanghai \033[0m"

## 安装net-tools

sudo apt install net-tools -y

ifconfig

echo -e "\033[32mnet-tools 已安装 \033[0m"


## 设置NTP为ntp.aliyun.com

# 备份timesyncd配置文件
sudo cp /etc/systemd/timesyncd.conf /etc/systemd/timesyncd.conf.bak

# 编辑timesyncd配置文件
sudo sed -i 's/^#NTP=/NTP=ntp.aliyun.com/' /etc/systemd/timesyncd.conf
sudo sed -i 's/^#FallbackNTP=ntp.ubuntu.com/FallbackNTP=ntp.ubuntu.com/' /etc/systemd/timesyncd.conf
sudo sed -i 's/^#RootDistanceMaxSec=5/RootDistanceMaxSec=5/' /etc/systemd/timesyncd.conf
sudo sed -i 's/^#PollIntervalMinSec=32/PollIntervalMinSec=32/' /etc/systemd/timesyncd.conf
sudo sed -i 's/^#PollIntervalMaxSec=2048/PollIntervalMaxSec=2048/' /etc/systemd/timesyncd.conf

# 重启timesyncd服务
sudo systemctl restart systemd-timesyncd

sudo cat /etc/systemd/timesyncd.conf

echo -e "\033[32mNTP已成功设置为 ntp.aliyun.com \033[0m"

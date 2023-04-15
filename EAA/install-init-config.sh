#!/bin/bash

# Update package
sudo apt-get update

# Change the SSH port to 65432
sudo sed -i 's/#Port 22/Port 65432/g' /etc/ssh/sshd_config

# Restart the SSH service
sudo systemctl restart sshd

# Install Google BBR and enable it
sudo modprobe tcp_bbr
echo "tcp_bbr" | sudo tee -a /etc/modules-load.d/modules.conf
echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Check SSH port is enabled
echo -e "\033[32mSSH port: \033[0m"
grep "Port 65432" /etc/ssh/sshd_config

# Check if BBR is enabled
echo -e "\033[32mBBR status: \033[0m"
sysctl net.ipv4.tcp_available_congestion_control
lsmod | grep bbr

# Output success messages
echo -e "\033[32mPort forwarding from port 22 to port 65432 has been configured successfully. \033[0m"
echo -e "\033[32mGoogle BBR has been enabled successfully. \033[0m"

# Delay of 10s
echo -e "\033[31mRestarting.......\033[0m"
sleep 10s

# reboot
sudo reboot

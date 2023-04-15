#!/bin/bash

# Update package list and upgrade packages
sudo apt-get update

sed -i 's/#Port 22/Port 65432/g' /etc/ssh/sshd_config

# Install Google BBR and enable it
sudo modprobe tcp_bbr
echo "tcp_bbr" | sudo tee -a /etc/modules-load.d/modules.conf
echo "net.core.default_qdisc=fq" | sudo tee -a /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control=bbr" | sudo tee -a /etc/sysctl.conf
sudo sysctl -p

# Check if BBR is enabled
echo "BBR status:"
lsmod | grep bbr

# Output success messages
echo "Port forwarding from port 22 to port $port_number has been configured successfully."
echo "Google BBR has been enabled successfully."

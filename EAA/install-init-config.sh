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

# Check if BBR is enabled
echo "BBR status:"
lsmod | grep bbr

# Output success messages
echo "Port forwarding from port 22 to port 65432 has been configured successfully."
echo "Google BBR has been enabled successfully."

# Delay of 10s
echo "Restarting......."
sleep 10s

# reboot
sudo reboot

#!/bin/bash

port_number=""
while getopts ":p:" opt; do
  case ${opt} in
    p )
      port_number=${OPTARG}
      ;;
    \? )
      echo "Invalid option: -$OPTARG" 1>&2
      exit 1
      ;;
    : )
      echo "Option -$OPTARG requires an argument." 1>&2
      exit 1
      ;;
  esac
done

if [[ -z $port_number ]]; then
    echo "Please specify the port number to map using the -p option."
    exit 1
fi

# Update package list and upgrade packages
sudo apt-get update && sudo apt-get upgrade -y

# Install necessary packages
sudo apt-get install -y curl iptables-persistent

# Enable port forwarding and configure iptables to forward port 22 to the specified port number
sudo sed -i 's/#net.ipv4.ip_forward=1/net.ipv4.ip_forward=1/g' /etc/sysctl.conf
sudo sysctl -p
sudo iptables -t nat -A PREROUTING -p tcp --dport 22 -j REDIRECT --to-port $port_number
sudo iptables-save | sudo tee /etc/iptables/rules.v4

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

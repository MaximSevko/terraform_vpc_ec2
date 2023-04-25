#!/bin/bash

sudo dnf install gcc git make
git clone https://git.zx2c4.com/wireguard-tools
make -C wireguard-tools/src -j$(nproc)
sudo make -C wireguard-tools/src install

wg genkey | sudo tee /etc/wireguard/private.key
sudo chmod go= /etc/wireguard/private.key
sudo cat /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public.key


sudo echo "PrivateKey = $(sudo cat /etc/wireguard/private.key)
Address = 10.81.22.0/24, fdf1:f187:de58::1/64
ListenPort = 12345

PostUp = iptables -A FORWARD -i %i -j ACCEPT; iptables -t nat -A POSTROUTING -o ens5 -j MASQUERADE
PostUp = ip6tables -A FORWARD -i %i -j ACCEPT; ip6tables -t nat -A POSTROUTING -o ens5 -j MASQUERADE
PostDown = iptables -D FORWARD -i %i -j ACCEPT; iptables -t nat -D POSTROUTING -o ens5 -j MASQUERADE
PostDown = ip6tables -D FORWARD -i %i -j ACCEPT; ip6tables -t nat -D POSTROUTING -o ens5 -j MASQUERADE

## client
[Peer]
PublicKey = iav9zTSPTrxu0cXKxsS0KhVA8HTUAXrK3PtHbpdQnAg=
AllowedIPs = 10.81.22.0/24, fdf1:f187:de58::/64

" | sudo tee /etc/wireguard/wg0.conf



sudo echo " net.ipv4.ip_forward=1
net.ipv6.conf.all.forwarding=1
" | sudo tee /etc/wireguard/wg0.conf

sudo sysctl -p

sudo yum install firewalld -y

sudo systemctl enable wg-quick@wg0.service

sudo systemctl start wg-quick@wg0.service

sudo wg

sudo wg-quick up wg0


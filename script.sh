#!/bin/bash

sudo dnf install gcc git make
git clone https://git.zx2c4.com/wireguard-tools
make -C wireguard-tools/src -j$(nproc)
sudo make -C wireguard-tools/src install

wg genkey | sudo tee /etc/wireguard/private.key
sudo chmod go= /etc/wireguard/private.key
sudo cat /etc/wireguard/private.key | wg pubkey | sudo tee /etc/wireguard/public                                                               .key



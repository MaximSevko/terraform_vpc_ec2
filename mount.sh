#! /bin/bash

sudo yum install xfsprogs -y

sudo mkdir /home/ec2-user/disk2
sudo mkdir /home/ec2-user/disk3


sudo mkfs -t xfs /dev/nvme1n1
sudo mkfs -t xfs /dev/nvme2n1

echo $(blkid | grep /dev/nvme1n1 | awk '{print $2}') /home/ec2-user/disk2 xfs defaults 1 1 >> /etc/fstab
echo $(blkid | grep /dev/nvme2n1 | awk '{print $2}') /home/ec2-user/disk3 xfs defaults 1 1 >> /etc/fstab

sudo mount -a

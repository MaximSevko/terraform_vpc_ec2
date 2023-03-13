#! /bin/bash
mkdir /home/ec2-user/disk2
mkdir /home/ec2-user/disk3

echo $(blkid | grep /dev/nvme1n1 | awk '{print $3}') /home/ec2-user/disk2 xfs defaults 1 1 >> /etc/fstab
echo $(blkid | grep /dev/nvme2n1 | awk '{print $3}') /home/ec2-user/disk3 xfs defaults 1 1 >> /etc/fstab

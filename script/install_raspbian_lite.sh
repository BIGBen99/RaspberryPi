#!/bin/bash

clear
if [ "$USER" != "root" ]
then
    echo "Please execute as root"
    echo "sudo ./install_raspbian_lite.sh"
    exit
fi

echo "Downloading latest release of Raspbian lite"
wget https://downloads.raspberrypi.org/raspbian_lite_latest --output-document=raspbian_lite_latest.zip

echo "Unziping archive of the latest realese of Raspbian lite"
unzip raspbian_lite_latest.zip

fdisk -l | grep --color "Dis.* /"
echo ""
echo -n "Type the filesystem (SD card) you want to install Raspbian lite: "
read -e sdcard
echo ""
echo -e "You choosed the following filesystem (SD card): \033[1;32m$sdcard\033[0m"
echo ""
echo -n -e "\033[0mDo you really want to overwrite \033[1;32m$sdcard \033[0m(\033[1;31mall data on this filesystem will be deleted\033[0m) ? [no/yes] "
read answer

if [ "$answer" != "yes" ]
then
    echo "Raspbian installation canceled"
    exit
fi

echo ""
echo "Umount $sdcard"
umount $sdcard'*'
echo "$sdcard and all its partitions have been unmounted"
raspbianImage=`ls | grep ".img"`
echo "Copy Raspbian ($raspbianImage) to the SD card"
dd if=$raspbianImage of=$sdcard status=progress conv=fsync bs=4M
echo "Raspbian copied to the SD card"
mkdir --parents '/media/'$USER'/boot'
mount $sdcard'1' '/media/'$USER'/boot'
touch '/media/'$USER'/boot/ssh'
umount '/media/'$USER'/boot'
rmdir '/media/'$USER'/boot'

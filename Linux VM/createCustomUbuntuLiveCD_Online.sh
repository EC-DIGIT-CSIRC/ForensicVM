#!/bin/bash

# Original Script found at: https://pastebin.com/NQUTWC1y
# Original Script Author: agilesetllc

# Updated Script Author: Bertrand Varlet

# Dependencies installation before running script:
apt-get update
apt-get install unzip xorriso -y

CDIMAGENAME='ubuntu-16.04.2-desktop-amd64.iso'
IMAGE_NAME='Custom1604'

echo "Copying $CDIMAGENAME to working directory..."

cd ~/.
mkdir custom-img
cp $CDIMAGENAME custom-img
cd custom-img

# Extract the CD .iso contents

#Mount the .iso to a local mount point. 'loop' is a read-only device, so mount will
# warn that it is mounting it read-only. You can use "-o loop,ro" to avoid that warning, if you like.
mkdir mnt
echo "Mounting the .iso as 'mnt' in the local directory. Password-up, please."
mount -o loop,ro $CDIMAGENAME mnt

#Extract the .iso contents into dir 'extract-cd'
mkdir extract-cd
rsync --exclude=/casper/filesystem.squashfs -a mnt/ extract-cd

#Extract the isohybrid MBR 'isohdpfx.bin' from the source ISO image using dd
dd if=$CDIMAGENAME bs=512 count=1 of=extract-cd/isolinux/isohdpfx.bin

# Extract the Desktop system
#Extract the SquashFS filesystem
unsquashfs mnt/casper/filesystem.squashfs
mv squashfs-root edit

#We are finished with the source .iso image. Unmount it.
umount mnt

#Delete the source .iso copy.
rm $CDIMAGENAME

# Prepare and chroot
cp /etc/resolv.conf edit/etc/
mount --bind /dev/ edit/dev

# Learned this inline scripting from https://askubuntu.com/questions/551195/scripting-chroot-how-to 
cat << EOF | chroot edit
mount -t proc none /proc
mount -t sysfs none /sys
mount -t devpts none /dev/pts

# "To avoid locale issues and in order to import GPG keys..."
export HOME=/root
export LC_ALL=C
dbus-uuidgen > /var/lib/dbus/machine-id
dpkg-divert --local --rename --add /sbin/initctl
ln -s /bin/true /sbin/initctl

#Customizations

# Example on how to add a user
# Add CSIRC user
# useradd csirc -G sudo,adm
# Set password for user
# cecho -e "forensics\nforensics" | passwd csirc

# Accept EULA for some software in debconf
# Example below kept for reference
# echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections

#Set Debian frontend to noninteractive
export "DEBIAN_FRONTEND=noninteractive"

#Update and Upgrade (distributions)
echo "deb [arch=amd64] http://archive.ubuntu.com/ubuntu xenial main restricted universe multiverse" > /etc/apt/sources.list
echo "deb [arch=amd64] http://archive.ubuntu.com/ubuntu xenial-updates main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb [arch=amd64] http://archive.ubuntu.com/ubuntu xenial-security main restricted universe multiverse" >> /etc/apt/sources.list
echo "deb [arch=amd64] http://deb.pinguin.lu/amd64 ./" >> /etc/apt/sources.list
# echo "deb [arch=amd64] http://ppa.launchpad.net/gift/stable/ubuntu xenial main" >> /etc/apt/sources.list
echo "deb [arch=amd64] http://artifacts.elastic.co/packages/6.x/apt stable main" >> /etc/apt/sources.list

# download the signing key of repo's and add it to apt-key list
wget -q http://deb.pinguin.lu/debsign_public.key -O- | apt-key add -
wget -q https://artifacts.elastic.co/GPG-KEY-elasticsearch -O- | apt-key add -
apt-get update

# Purge unwanted applications/software
apt-get purge thunderbird aisleriot webbrowser-app cheese cheese-common gnome-mahjongg gnome-mines onboard onboard-data qml-module-ubuntu-onlineaccounts account-plugin-facebook account-plugin-flickr account-plugin-google remmina rhythmbox gnome-orca shotwell simple-scan gnome-sudoku transmission-common transmission-gtk wireless-regdb wireless-tools -y

# Install of fred
apt-get install libqtwebkit4 -y
wget http://security.ubuntu.com/ubuntu/pool/main/q/qt4-x11/libqt4-webkit-dbg_4.8.5+git192-g085f851+dfsg-2ubuntu4.1_amd64.deb
apt-get install ./libqt4-webkit_4.8.5+git192-g085f851+dfsg-2ubuntu4.1_amd64.deb
apt-get install fred fred-reports -y

# Install of disloker
apt-get install gcc cmake make libfuse-dev libmbedtls-dev ruby-dev -y
wget https://github.com/Aorimn/dislocker/archive/v0.7.1.tar.gz -O dislocker-0.7.1.tar.gz
tar -xzvf dislocker-0.7.1.tar.gz
cd dislocker-0.7.1
cmake .
make
make install
cd -

# Install of Regripper
apt-get install libparse-win32registry-perl -y
wget https://github.com/keydet89/RegRipper2.8/archive/master.zip -O regripper_2.8-linux.zip
unzip regripper_2.8-linux.zip
mv RegRipper2.8-master /opt/regripper
cd /opt/regripper
chmod 755 rip.pl 
cd -

# apt install most of the tools we need
apt-get install unity-control-center -y
apt-get install cabextract -y
apt-get install python -y
apt-get install python-pip -y
apt-get install volatility -y
apt-get install plaso -y
apt-get install sleuthkit -y
apt-get install ewf-tools -y
apt-get install tcpdump -y
apt-get install nfdump -y
apt-get install wireshark -y
apt-get install tshark -y
apt-get install autoconf -y
apt-get install automake -y
apt-get install autotools-dev -y
apt-get install exif -y
apt-get install dc3dd -y
apt-get install guymager-beta -y
apt-get install hexedit -y
apt-get install bless -y
apt-get install mono-complete -y
apt-get install sqlitebrowser -y
apt-get install curl -y
apt-get install xmount -y
apt-get install yara -y
apt-get install libfuse-dev -y
apt-get install libmbedtls-dev -y
apt-get install build-essential -y
apt-get install radare2 -y
apt-get install tlsh-tools -y
apt-get install dos2unix -y
apt-get install libevtx-utils -y
apt-get install unzip -y
apt-get install parallel -y
apt-get install jq -y
apt-get install libncurses5-dev -y
apt-get install p7zip-full -y 
apt-get install p7zip-rar -y
apt-get install tcpstat -y
apt-get install tcpxtract -y
apt-get install tcpreplay -y
apt-get install tcpslice -y
apt-get install tcptrace -y
apt-get install vim -y
apt-get install foremost -y
apt-get install testdisk -y
apt-get install zsh -y
apt-get install golang -y
apt-get install binwalk -y
apt-get install openjdk-8-jdk -y
apt-get install elasticsearch -y
apt-get install filebeat -y
apt-get install kibana -y

# Install VM Tools
apt-get install open-vm-tools-desktop -y

# pip installs
pip install virtualenv 
pip install pyopenssl 
pip install python-evtx 
pip install python-registry 
pip install virustotal-api 
pip install artifacts 
pip install bencode 

#Download pip, setuptools, wheels for the virtualEnv
pip download pip setuptools wheel -d /tmp 

#Changing directory to store the VirtualEnv
cd /opt

#Create new virtualenv for rekall
python -m virtualenv VErekall --no-download --extra-search-dir=/tmp

#Activate VErekall virtualEnv
source ./VErekall/bin/activate

#Install rekall
pip install pyrekall 

# Exiting virtualEnv VErekall
deactivate

# Download Rekall profiles
wget https://github.com/google/rekall-profiles/archive/gh-pages.zip -O rekall-profiles.zip
mv rekall-profiles.zip /opt/VErekall
cd /opt/VErekall/
unzip rekall-profiles.zip

# Remove profiles we don't need (Keep only windows related profiles)
rm -rf /opt/VErekall/rekall-profiles-gh-pages/v1.0/Linux
rm -rf /opt/VErekall/rekall-profiles-gh-pages/v1.0/OSX
rm -rf /opt/VErekall/rekall-profiles-gh-pages/v1.0/src/Linux
rm -rf /opt/VErekall/rekall-profiles-gh-pages/v1.0/Ubuntu
rm -rf /opt/VErekall/rekall-profiles-gh-pages/v1.0/Debian
rm -rf /opt/VErekall/rekall-profiles.zip

# Configure the use of the local profiles
mkdir /opt/VErekall/rekall_cache
mkdir /opt/VErekall/Scripts
echo """
# This forces Rekall to assume your home directory is /opt/VErekall .
home: /opt/VErekall/

repository_path: 
  - /opt/VErekall/rekall-profiles-gh-pages/

# Do not use a persistent cache.
cache: memory

# We do not want to contact MS symbol server at all
autodetect_build_local: none

# Where Rekall will store cached files.
cache_dir: /opt/VErekall/rekall_cache/
""" > /opt/VErekall/Scripts/.rekallrc

#Create new virtualenv for Scapy
cd /opt
python -m virtualenv VEscapy --no-download --extra-search-dir=/tmp

#Activate VErekall virtualEnv
source ./VEscapy/bin/activate

#Install Scapy
pip install IPython 
pip install numpy 
pip install pycrypto 
pip install pyx==0.12.1 
pip install matplotlib 
pip install pyreadline 
pip install libpcap 
pip install ecdsa 
pip install scapy 

# Exiting virtualEnv VEscapy
deactivate

#Return to previous directory
cd

# Update & upgrade
apt-get update
apt-get upgrade -y
apt-get dist-upgrade -y

apt-get autoremove -y
apt-get autoclean -y

# Customise gnome settings
# Disable automount
dbus-launch --exit-with-session gsettings set org.gnome.desktop.media-handling automount false
dbus-launch --exit-with-session gsettings set org.gnome.desktop.media-handling autorun-never true

# Setting Keyboard layouts
dbus-launch --exit-with-session gsettings set org.gnome.desktop.input-sources sources "[('xkb', 'us'), ('xkb', 'be'), ('xkb', 'ch')]"

# Disable automount of disks
echo 'ACTION=="add|change", SUBSYSTEM=="block", ENV{UDISKS_IGNORE}="1"' > /etc/udev/rules.d/00-noautomount.rules

#Clean up
rm -rf dislocker-0.7.1.tar.gz
rm -rf dislocker-0.7.1
rm -rf libqt4-webkit_4.8.5+git192-g085f851+dfsg-2ubuntu4.1_amd64.deb
rm -rf regripper_2.8.zip
rm -rf /opt/click.ubuntu.com
rm -rf /tmp/* ~/.bash_history
rm /var/lib/dbus/machine-id
rm /sbin/initctl
dpkg-divert --rename --remove /sbin/initctl

# "now umount (unmount) special filesystems and exit chroot"
umount /proc || umount -lf /proc
umount /sys
umount /dev/pts
EOF

umount edit/dev

echo "Regenerate the manifest"

#Regenerate the manifest
chmod +w extract-cd/casper/filesystem.manifest
chroot edit dpkg-query -W --showformat='${Package} ${Version}\n' | tee extract-cd/casper/filesystem.manifest
cp extract-cd/casper/filesystem.manifest extract-cd/casper/filesystem.manifest-desktop
sed -i '/ubiquity/d' extract-cd/casper/filesystem.manifest-desktop
sed -i '/casper/d' extract-cd/casper/filesystem.manifest-desktop

#Compress the filesystem
# Delete any existing squashfs - normally nothing to delete/rm.
rm extract-cd/casper/filesystem.squashfs
mksquashfs edit extract-cd/casper/filesystem.squashfs -b 1048576

#"Update the filesystem.size file, which is needed by the installer"
printf $(du -sx --block-size=1 edit | cut -f1) | tee extract-cd/casper/filesystem.size

#"Remove old md5sum.txt and calculate new md5 sums"
cd extract-cd
rm md5sum.txt
find -type f -print0 | xargs -0 md5sum | grep -v isolinux/boot.cat | tee md5sum.txt

#"Create the ISO image"
xorriso -as mkisofs -isohybrid-mbr isolinux/isohdpfx.bin -c isolinux/boot.cat -b isolinux/isolinux.bin -no-emul-boot -boot-load-size 4 -boot-info-table -eltorito-alt-boot -e boot/grub/efi.img -no-emul-boot -isohybrid-gpt-basdat -o ../$IMAGE_NAME.iso .

# Not necessary, but you can check that a bootable partition is visible to fdisk. 
# If no bootable partiction is visible to fdisk, my experience is that the ISO will not boot from USB.
# If so, we should be good to go.
fdisk -lu ../$IMAGE_NAME.iso
#EOF

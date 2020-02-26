#!/bin/bash
accountCreation(){
	PASSWORD="P@ssw0rd"
	echo 'creating user accounts'
	useradd -d /home/kane -m -s /bin/bash kane
	useradd -d /home/nicholas -m -s /bin/bash nicholas
	useradd -d /home/gabriel -m -s /bin/bash gabriel
	useradd -d /home/samsojl1 -m -s /bin/bash samsojl1
	useradd -d /home/alister -m -s /bin/bash alister
	useradd -d /home/regan -m -s /bin/bash regan
	echo 'adding users to sudo'
	usermod -aG sudo kane
	usermod -aG sudo nicholas
	usermod -aG sudo gabriel
	usermod -aG sudo samsojl1
	usermod -aG sudo alister
	usermod -aG sudo regan
	echo 'setting default passwords for accounts'
	echo "kane":"$PASSWORD" | chpasswd
	echo "nicholas":"$PASSWORD" | chpasswd
	echo "gabriel":"$PASSWORD" | chpasswd
	echo "samsojl1":"$PASSWORD" | chpasswd
	echo "alister":"$PASSWORD" | chpasswd
	echo "regan":"$PASSWORD" | chpasswd
	echo 'forcing password change on next login'
	chage -d 0 kane
	chage -d 0 nicholas
	chage -d 0 gabriel
	chage -d 0 samsojl1
	chage -d 0 alister
	chage -d 0 regan
}

updateHost(){
	echo 'updating /hostname and /hosts to zeus'
	echo 'zeus' > /etc/hostname
	echo '127.0.0.1 	zeus' > /etc/hosts
	echo '::1		localhost ip6-localhost ip6-loopback' >> /etc/hosts
	echo 'ff02::1		ip6-allnodes' >> /etc/hosts
	echo 'ff02::2		ip6-allrouters' >> /etc/hosts
	echo '127.0.0.1 	raspberrypi' >> /etc/hosts
}

bashCreate(){
	echo 'Creating .bash_aliases for users'
	touch /home/kane/.bash_aliases
	echo '#!/bin/bash' >/home/kane/.bash_aliases
	echo "alias lsl='"ls -lisa"'" >> /home/kane/.bash_aliases
	cp /home/kane/.bash_aliases /home/nicholas/
	cp /home/kane/.bash_aliases /home/gabriel/
	cp /home/kane/.bash_aliases /home/samsojl1/
	cp /home/kane/.bash_aliases /home/alister/
	cp /home/kane/.bash_aliases /home/regan/
}
timeAndDate(){
	echo 'Installing NTP'
	sudo apt install ntp
	echo 'Enabling NTP'
	sudo systemctl enable ntp
	echo 'Setting Time and Date'
	sudo timedatectl set-ntp 1

	sudo rm /etc/localtime
	sudo ln -s /usr/share/zoneinfo/Pacific/Auckland /etc/localtime
}
removeUnwanted(){
	echo 'Uninstalling and Removing Bluetooth from the device'
	sudo apt --autoremove purge bluez
}
accountCreation
updateHost
bashCreate
echo 'Installing vim'
sudo apt install vim
echo 'Updating Software'
sudo apt update
sudo apt full-upgrade
echo 'Configuring Time'
timeAndDate
removeUnwanted

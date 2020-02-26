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

	echo "kane":"$PASSWORD" | chpasswd
	echo "nicholas":"$PASSWORD" | chpasswd
	echo "gabriel":"$PASSWORD" | chpasswd
	echo "samsojl1":"$PASSWORD" | chpasswd
	echo "alister":"$PASSWORD" | chpasswd
	echo "regan":"$PASSWORD" | chpasswd
	
	chage -d 0 kane
	chage -d 0 nicholas
	chage -d 0 gabriel
	chage -d 0 samsojl1
	chage -d 0 alister
	chage -d 0 regan
}

updateHost(){
	echo 'poseidon' > /etc/hostname
	echo '127.0.0.1 	poseidon' > /etc/hosts
	echo '::1		localhost ip6-localhost ip6-loopback' >> /etc/hosts
	echo 'ff02::1		ip6-allnodes' >> /etc/hosts
	echo 'ff02::2		ip6-allrouters' >> /etc/hosts
	echo '127.0.0.1 	raspberrypi' >> /etc/hosts
}

accountCreation
updateHost
sudo apt install vim



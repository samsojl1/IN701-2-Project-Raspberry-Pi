#!/bin/bash
accountCreation(){
	#26/02/2020 note - jonathon
	#at some point this will be updated to create the users accounts from a list of names in a csv this will allow for the ability to scale quickly
	#the user creation will also be added to its own script so if a new user is ever added to the csv you can just run the account creation script to add them instead of running this one again
	#but thats a plan for later maybe in a week or twoish
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
	echo 'updating /hostname and /hosts to poseidon'
	echo 'poseidon' > /etc/hostname
	echo '127.0.0.1 	poseidon' > /etc/hosts
	echo '::1		localhost ip6-localhost ip6-loopback' >> /etc/hosts
	echo 'ff02::1		ip6-allnodes' >> /etc/hosts
	echo 'ff02::2		ip6-allrouters' >> /etc/hosts
	echo '127.0.0.1 	raspberrypi' >> /etc/hosts
}

bashCreate(){
	#note 26/02/2020 - jonathon
	#when the change for account creation happens this will also need to be updated to a variable instead of set
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
	echo 'Configuring Time'
	sudo rm /etc/localtime
	sudo ln -s /usr/share/zoneinfo/Pacific/Auckland /etc/localtime
	echo 'Installing NTP'
	sudo apt-get -y install ntp
	echo 'Enabling NTP'
	sudo systemctl enable ntp
	echo 'Setting Time and Date'
	sudo timedatectl set-ntp 1
}
removeUnwanted(){
	echo 'Uninstalling and Removing Bluetooth from the device'
	sudo apt --autoremove purge bluez
}
updateAndInstall(){
	#note 26/02/2020 - jonathon
	#i might split these functions into their own scripts in order to reduce repeating functions if the scripts need to be ran again

	echo 'Installing vim'
	sudo apt-get -y install vim
	echo 'Installing Nmap'
	echo 'DO NOT USE IT AGAINST AN OUTSIDE NETWORK STICK TO RASPBERRY PI'
	sudo apt-get -y install nmap
	echo 'Updating Software'
	sudo apt-get -y update
	sudo apt-get -y full-upgrade
}
sshConfig(){
	SSHD='/etc/ssh/sshd_config'
	#sudo cp /etc/ssh/sshd_config /etc/ssh/sshd_config.bak
	sudo touch /etc/ssh/banner.txt
	echo '	###############################################################
	#                    Welcome to Ubuntu-Server                 #
	#          All connections are monitored and recorded         #
	#  Disconnect IMMEDIATELY if you are not an authorized user!  #
	###############################################################
	# If you attempt to illegally access this server you will be  #
	# breaking Section 250 of the New Zealand Crime Act (1969):   #
	# Damaging or interfering with computer system which carriers #
	# a maximum penalty (imprisonment) of 7 to 10 years.          #
	###############################################################' > /etc/ssh/banner.txt
	#note 26/02/2020 - jonathon
	#50/50 this works as i plan
	#the plan for the following lines of code is that it will create a blank sshd_config file that will then insert the base setup wanted for these machines 
	#this will in theory allow for rapid setup of new machines allowing for scaling to occur
	#in order to added more things to the sshd_config you will need to refer to the sshd_config.bak to get the options as this works on a blank sshd_config
	#its quicker to setup to get the machine back to where it was if it bricks but its more annoying as you need to refer to another file
	sudo rm /etc/ssh/sshd_config
	sudo touch /etc/ssh/sshd_config
	#note 26/02/2020 - jonathon
	#changed the redirect from /etc/ssh/sshd_config to a variable called SSHD which has the file path this allows for less writing
	#might find a way for this to look a bit better 
	echo 'Port 4096' >> $SSHD #/etc/ssh/sshd_config
	echo 'LogLevel VERBOSE' >> $SSHD #/etc/ssh/sshd_config
	echo 'LoginGraceTime 60' >> $SSHD #/etc/ssh/sshd_config
	echo 'ChallengeResponseAuthentication no' >> $SSHD #/etc/ssh/sshd_config
	echo 'UsePAM yes' >> $SSHD #/etc/ssh/sshd_config
	echo 'X11Forwarding no' >> $SSHD #/etc/ssh/sshd_config
	echo 'PrintMotd no' >> $SSHD #/etc/ssh/sshd_config
	echo 'PrintLastLog no' >> $SSHD #/etc/ssh/sshd_config
	echo 'Banner /etc/ssh/banner.txt' >> $SSHD #/etc/ssh/sshd_config
	echo 'AcceptEnv LANG LC_*' >> $SSHD #/etc/ssh/sshd_config
	echo 'Subsystem		sftp	/usr/lib/openssh/sftp-server' >> $SSHD #/etc/ssh/sshd_config
}
accountCreation
updateHost
bashCreate
timeAndDate
removeUnwanted
sshConfig
updateAndInstall

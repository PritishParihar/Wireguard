#!/bin/bash
read -p "Enter one number from 1 ,2 ,3: " number
#packages = "apt-transport-https,ca-certificates,curl,gnupg-agent,software-properties-common"
if [ $number -eq '1' ]
then
	echo "you pressed one"
	if [[ $(which docker) && $(docker --version) ]]; then
		echo "Update docker"
	else
		echo "You don't have docker installed."
		echo "Installing docker..."
		if [ `whoami` != 'root' ]
		then
			echo "Root priviledges require!"
			exit 0
		fi
			echo "Root priviledges exists"
		r=$(awk -F= '{print $2}' /etc/os-release |grep rhel)
		d=$(awk -F= '{print $2}' /etc/os-release |grep debian)

		if [[ $r == *rhel* ]];then
			echo "This is $r"
		elif [[ $d == *debian* ]];then
			echo "This is $d"
			if ping -q -c 1 -W 1 8.8.8.8 >/dev/null; then
  				echo "Internet is UP"
				for pkg  in "apt-transport-https" "ca-certificates" "curl" "gnupg-agent" "software-properties-common";
				do
					find = dpkg -s $pkg | echo $?
				done
			else
				echo "Internet is down"
			fi
		fi
	fi

elif [ $number -eq '2' ]
then
	echo "you  pressed two"
elif [ $number -eq '3' ]
then
	echo "you press three."
	echo "exiting ...."
	exit 0
elif [ -z $number ]
then
	exit 0
else
	exit 0
fi



# Automating wireguard using docker compose

## Refer link:

[docker-compose.yaml file](https://hub.docker.com/r/linuxserver/wireguard)

### Module refer link
[Read more about docker modules](https://docs.docker.com/engine/reference/run/)


## Configuring Server side:
[Installing pre-requisite]

```ruby
Precaution
Allow port = 51820
```

Packages to install:
`sudo apt-get install apt-transport-https ca-certificates curl gnupg-agent software-properties-common
`
Description about packages:

apt-transport-https - allows the use of repositories accessed via the HTTP Secure protocol (HTTPS),
ca-certificates - Certificate Authentication
curl  - Client URL, develop to transfer data to and from server
gnupg-agent - Daemon to manage private keys independently from any protocol
software-properties-common  - Provide useful scripts for adding and removing PPAs and DBUS backends, without this we have to manually add or remove PPAs and as well as subsidiary

### [Installing docker]

`curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -`

Description about flags:

-f = fail [silent output + no server error]	#-s = no progress bar
-S = error shown if something goes wrong
-L = change in location

### Adding repo
`sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"`

### Update and installing docker files
`sudo apt-get update && sudo apt-get install docker-ce docker-ce-cli containerd.io`

### Downloading docker-compose file
`sudo curl -L "https://github.com/docker/compose/releases/download/1.26.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose`

### Setting Executable permission
`sudo chmod +x /usr/local/bin/docker-compose`


### remove sudo from every docker
`sudo usermod -aG docker $USER`

### to reload all the membership of the group
`newgrp docker`

### to check docker is successfully installed
`docker run hello-world`

### to see docker-compose version
`docker-compose version`

Installation of docker and docker-compose complete!


## Installing wireguard container

### Just to keep things clean, let’s create a separate directory
`sudo mkdir /opt/wireguard-server`

#Getting ownership of folder
sudo chown $USER:$USER /opt/wireguard-server/

#Let’s jump into the directory
cd /opt/wireguard-server

# creating docker-compose yaml file
nano docker-compose.yaml
# copy paste below text into yaml file
version: "2.1"
services:
  wireguard:
    image: linuxserver/wireguard
    container_name: wireguard
    cap_add:
      - NET_ADMIN 	# Perform various network-related operations.
      - SYS_MODULE	# Load and unload kernel modules.
    environment:
      - PUID=1000
      - PGID=1000
      - TZ=Europe/London		#Asia/Kolkata
      - SERVERURL=auto  #optional: auto check public ip addr and assign
      - SERVERPORT=51820 #optional
      - PEERS=1 #optional
      - PEERDNS=auto #optional
      - INTERNAL_SUBNET=10.13.13.0 #optional
    volumes:
      - /opt/wireguard-server/config:/config
      - /lib/modules:/lib/modules
    ports:
      - 51820:51820/udp
    sysctls:
      - net.ipv4.conf.all.src_valid_mark=1
    restart: unless-stopped


# Compose yaml file
docker-compose up -d

#check container
docker-compose ps

# Executing wg command inside docker container
docker exec -it wireguard wg
cd config/peer1

#Copy peer1.conf file to client machine
scp peer1.conf client@<IP>



Client Side:

# Update repo
sudo apt update

# wireguard on client side with resolvconf (for resolution of DNS queries )
sudo apt install -y  wireguard resolvconf

# Move the peer1 file to wireguard directory
sudo mv peer1.conf /etc/wireguard/wg0.conf

# Connecting to server
sudo wg-quick up wg0

# to check if connected to server
wg

<Whola! Done>


To check connectivity between server and client:

#Run inside docker container [with elevated privileges ]
apt update && apt install tcpdump

tcpdump -envi wg0 host 8.8.8.8

# Now ping 8.8.8.8 from client side

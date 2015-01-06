#!/bin/bash

#migrated this update out to avoid error in resolving host.

HOSTNAME="$1"

#check number of arguments before proceed
echo "============================================================" >&2
echo "(0) Checking arguments before proceed" >&2
echo "Expecting: $0 <HOSTNAME>" >&2
echo "* <HOSTNAME> : hostname of the machine to setup." >&2
echo "============================================================" >&2
if [ "$#" -ne 1 ]; then
  echo "Error: Please include <HOSTNAME> as the argument. " >&2
  exit 1
fi


# get a list of ethernet network interfaces that are up
echo "============================================================" >&2
echo "(1.1) get a list of ethernet network interfaces that are up" >&2
echo "============================================================" >&2
echo "exec: eth_ifs=$(/bin/netstat -i | /bin/grep eth | /usr/bin/awk '{print $1}')" >&2
echo "exec: nifs=$(echo $eth_ifs | wc -w)" >&2
echo "exec: [ $nifs -ge 1 ] || exit 0;" >&2
echo "------------------------------------------------------------" >&2
eth_ifs=$(/bin/netstat -i | /bin/grep eth | /usr/bin/awk '{print $1}')
nifs=$(echo $eth_ifs | wc -w)
[ $nifs -ge 1 ] || exit 0;

echo -e "\n" >&2

# Select the first interface 
echo "============================================================" >&2
echo "(1.2) Select the first interface " >&2
echo "============================================================" >&2
echo "exec: eth1=$(echo \"$eth_ifs\" | /usr/bin/head -n 1)" >&2
echo "------------------------------------------------------------" >&2
sh -c "eth1=$(echo \"$eth_ifs\" | /usr/bin/head -n 1)"

echo -e "\n" >&2

# Get the IP address
echo "============================================================" >&2
echo "(1.3) Get the IP address" >&2
echo "============================================================" >&2
echo "exec: eth_ip=$(/sbin/ifconfig $eth1 | /bin/grep 'inet addr:' | /usr/bin/head -n 1 | /usr/bin/awk '{print $2}' | /bin/sed 's/addr://')" >&2
echo "------------------------------------------------------------" >&2
eth_ip=$(/sbin/ifconfig $eth1 | /bin/grep 'inet addr:' | /usr/bin/head -n 1 | /usr/bin/awk '{print $2}' | /bin/sed 's/addr://')

echo -e "\n" >&2

echo "============================================================" >&2
echo "(1.4) Replacing hosts & hostname file" >&2
echo "============================================================" >&2
echo "HOSTNAME=${HOSTNAME} | eth_ip=${eth_ip}" >&2
if [ HOSTNAME != "" ] && [ eth_ip != "" ]; then
	echo "exec: sudo sh -c \"sed 's/host_ip/${eth_ip}/g ; s/host_name/${HOSTNAME}/g' < /home/hduser/mmu-conf/networks/hosts > /etc/hosts\"" >&2
	echo "exec: sudo sh -c \"sed 's/host_name/${HOSTNAME}/g' < /home/hduser/mmu-conf/networks/hostname > /etc/hostname\"" >&2
	echo "------------------------------------------------------------" >&2
	sudo sh -c "sed 's/host_ip/${eth_ip}/g ; s/host_name/${HOSTNAME}/g' < /home/hduser/mmu-conf/networks/hosts > /etc/hosts"
	#sed "s/host_ip/$eth_ip/g ; s/host_name/${HOSTNAME}/g" < /etc/hosts > $HDUSER_HOME/mmu-conf/networks/hosts
	sudo sh -c "sed 's/host_name/${HOSTNAME}/g' < /home/hduser/mmu-conf/networks/hostname > /etc/hostname"
	#sed "s/host_name/${HOSTNAME}/g" < /etc/hostname > $HDUSER_HOME/mmu-conf/networks/hostname
else
	echo "HOSTNAME or/and eth_ip is/are empty. not replacing hostname" >&2
	echo "------------------------------------------------------------" >&2
fi


echo -e "\n\n" >&2
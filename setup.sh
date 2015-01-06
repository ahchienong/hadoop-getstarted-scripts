#!/bin/bash

export HDUSER_HOME=/home/hduser
#check number of arguments before proceed
echo "============================================================" >&2
echo "(0) Checking arguments before proceed" >&2
echo "Expecting: $0 <HOSTNAME> <NODETYPE>" >&2
echo "* <HOSTNAME> : hostname of the machine to setup." >&2
echo "* <NODETYPE> : 'M' -> Master ; 'S' -> Slaves" >&2
echo "============================================================" >&2
if [ "$#" -ne 2 ]; then
  echo "Error: Please include <HOSTNAME> <NODE_TYPE> as the arguments. " >&2
  exit 1
fi
if [ $2 != "M" ] && [ $2 != "S" ]; then
  echo "Error: Invalid <NODETYPE> input." >&2
  echo "'M' -> Master ; 'S' -> Slaves" >&2
  exit 1
fi

#Assign arguments to local variables
HOSTNAME="$1"
NODETYPE="$2"

# Get Utilities required
echo "============================================================" >&2
echo "(2) Install Utilities required" >&2
echo "============================================================" >&2
echo "exec: sudo apt-get install ssh rsync lzop openjdk-7-jdk" >&2
echo "------------------------------------------------------------" >&2
sudo apt-get install ssh rsync lzop openjdk-7-jdk

echo -e "\n\n" >&2

# Update OS & Libs
echo "============================================================" >&2
echo "(3) Update OS & Libs" >&2
echo "============================================================" >&2
echo "exec: sudo apt-get update" >&2
echo "------------------------------------------------------------" >&2
sudo apt-get update

echo "------------------------------------------------------------" >&2
echo "exec: sudo apt-get upgrade" >&2
echo "------------------------------------------------------------" >&2
sudo apt-get upgrade

echo -e "\n\n" >&2

# Setup hadoop group and user account (existing user)
echo "============================================================" >&2
echo "(4) Setup hadoop group and user account (existing user)" >&2
echo "============================================================" >&2
echo "exec: sudo apt-get update" >&2
echo "------------------------------------------------------------" >&2
sudo addgroup hadoop
#sudo adduser --ingroup hadoop hduser
sudo adduser hduser hadoop

# Login as hduser & continue with the rest of the configurations
#sudo su - hduser

# Create PublicKey
echo "============================================================" >&2
echo "(5) Create PublicKey" >&2
echo "============================================================" >&2
echo "exec: ssh-keygen -t rsa -P \"\" -f ~/.ssh/id_rsa" >&2
echo "------------------------------------------------------------" >&2
ssh-keygen -t rsa -P "" -f ~/.ssh/id_rsa

echo "------------------------------------------------------------" >&2
echo "exec: cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys" >&2
echo "------------------------------------------------------------" >&2
cat ~/.ssh/id_rsa.pub >> ~/.ssh/authorized_keys

echo -e "\n\n" >&2

# Check for Hadoop distribution
echo "============================================================" >&2
echo "(6) Check for Hadoop Distribution" >&2
echo "============================================================" >&2
export HADOOP_HOME=/usr/local/hadoop

#if find "$HADOOP_HOME" -mindepth 1 -print -quit | grep -q .; then
if [ -d "$HADOOP_HOME" ]; then
	echo "------------------------------------------------------------" >&2
	echo "Hadoop folder existed in $HADOOP_HOME." >&2
	echo "------------------------------------------------------------" >&2

else
	echo "------------------------------------------------------------" >&2
	echo "Hadoop folder not found. Grab a copy of Hadoop" >&2
	echo "------------------------------------------------------------" >&2
	# Grab copy of hadoop & extract & update owner
	echo "exec: wget mirror.olnevhost.net/pub/apache/hadoop/common/stable/hadoop-2.6.0.tar.gz" >&2
	wget mirror.olnevhost.net/pub/apache/hadoop/common/stable/hadoop-2.6.0.tar.gz
	
	echo "------------------------------------------------------------" >&2
	echo "exec: tar -zxf hadoop-2.6.0.tar.gz" >&2
	echo "unzipping hadoop-2.6.0.tar.gz ..." >&2
	echo "------------------------------------------------------------" >&2	
	tar -zxf hadoop-2.6.0.tar.gz
	
	echo "------------------------------------------------------------" >&2	
	echo "exec: sudo mv hadoop-2.6.0 /usr/local/hadoop" >&2
	echo "------------------------------------------------------------" >&2
	sudo mv hadoop-2.6.0 /usr/local/hadoop
	
	echo "------------------------------------------------------------" >&2	
	echo "exec: sudo chown -R hduser:hadoop /usr/local/hadoop" >&2
	echo "------------------------------------------------------------" >&2
	sudo chown -R hduser:hadoop /usr/local/hadoop
fi

echo -e "\n\n" >&2

echo "============================================================" >&2
echo "(7) Create Directory for Hadoop to store data files" >&2
echo "============================================================" >&2
echo "exec: sudo mkdir -p /app/hadoop/tmp" >&2
echo "------------------------------------------------------------" >&2
# Create Directory for Hadoop to store its data files
sudo mkdir -p /app/hadoop/tmp

echo "exec: sudo chown hduser:hadoop /app/hadoop/tmp" >&2
echo "------------------------------------------------------------" >&2
sudo chown hduser:hadoop /app/hadoop/tmp

echo "exec: sudo chmod 750 /app/hadoop/tmp" >&2
echo "------------------------------------------------------------" >&2
sudo chmod 750 /app/hadoop/tmp

# Update Hadoop config parameters
#sudo vi /usr/local/hadoop/etc/hadoop/hadoop-env.sh


# Setting Up Data Directory & Logs
# NAMENODE ONLY
#mkdir -pv /usr/local/hadoop/data/namenode

echo "============================================================" >&2
echo "(8) Setting Up Data Directory & Logs [NAMENODE/DATANODE]" >&2
echo "============================================================" >&2

if [ NODETYPE == "M" ]; then
	echo "NODETYPE = Master , Creating Namenode Directory" >&2
	echo "exec: mkdir -pv /usr/local/hadoop/data/namenode" >&2
	echo "------------------------------------------------------------" >&2
	mkdir -pv /usr/local/hadoop/data/namenode
fi

echo "exec: mkdir -pv /usr/local/hadoop/data/datanode" >&2
echo "------------------------------------------------------------" >&2
# DATANODE (ALL Machines)
mkdir -pv /usr/local/hadoop/data/datanode

echo -e "\n\n" >&2

echo "exec: ~/updatehost.sh ${HOSTNAME}" >&2
sh -c "~/updatehost.sh ${HOSTNAME}"

echo "============================DONE============================" >&2









HGS - Hadoop GetStarted Scripts
===

:elephant: Helper scripts to get started with Hadoop.

**Scripts:**

:ballot_box_with_check: setup.sh

:ballot_box_with_check: init-hdfs

:ballot_box_with_check: start-hadoop

:ballot_box_with_check: stop-hadoop

:ballot_box_with_check: restart-hadoop

:ballot_box_with_check: reset-hadoop

===

**Templates:**

:ballot_box_with_check: mmu-conf/template/core-site.xml

:ballot_box_with_check: mmu-conf/template/hdfs-site.xml

:ballot_box_with_check: mmu-conf/template/mapred-site.xml

:ballot_box_with_check: mmu-conf/template/masters

:ballot_box_with_check: mmu-conf/template/slaves

:ballot_box_with_check: mmu-conf/networks/hostname

:ballot_box_with_check: mmu-conf/networks/hosts

:ballot_box_with_check: .bashrc

===

**Notes:**

:notebook: These scripts are designed for Debian Operating System. 

:notebook: Fully tested on Ubuntu Server (64-bit) [ubuntu-14.04.1-server-amd64] - http://www.ubuntu.com/download/server.

:notebook: Part of **GoHadoop** project to setup Hadoop Clusters in Virtual Machines.

===

**TODOs**

There's still plenty of work to do..

:white_medium_square: update of `hosts` file with all the hostnames & ip addresses

:white_medium_square: distribution of SSH public key (for SSH access)

:white_medium_square: update `masters` and `slaves` files with all the hadoop machines

:white_medium_square: update `*-site.xml` when start hadoop (assign master/namenode hostname & update correct replication of dfs)

:white_medium_square: What else? Let me know.

#!/bin/bash

# /*************************************************************************************************************************
#                     OCI: Zabbix-Agent2 install work on RHEL/OEL6.x


a=$HOSTNAME
# IMPORTANT rpms must be installed as root user

####################################
# Stop Zabbix agent and turn off
####################################

service zabbix-agent stop
chkconfig zabbix-agent off

####################################
# Install for RHEL/OEL 6.x
####################################

cd /root/6.x_agents

rpm -ihv *.rpm
service zabbix-agent2 start
chkconfig zabbix-agent2 on


sed -i "s/ServerActive=127.0.0.1/ServerActive=127.0.0.1,10.22.128.6/g" /etc/zabbix/zabbix_agent2.conf
sed -i "s/Server=127.0.0.1/Server=127.0.0.1,10.22.128.6/g" /etc/zabbix/zabbix_agent2.conf
sed -i "s/Hostname=Zabbix server/Hostname=$a/g" /etc/zabbix/zabbix_agent2.conf
sed -i '290 i Include=/u01/app/zabbix-agent/userparams.conf.d' /etc/zabbix/zabbix_agent2.conf


####################################
# Restart Zabbix-Agent2
####################################

service zabbix-agent2 restart

####################################
# Check the logs for errors
####################################

cat /var/log/zabbix/zabbix_agent2.log
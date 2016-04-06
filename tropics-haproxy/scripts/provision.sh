#!/bin/sh
#Variables
local_ip=10.1.132.161

#dependencies
yum install haproxy -y
yum install telnet -y
yum install vim -y
chkconfig haproxy on
cp /etc/haproxy/haproxy.cfg /etc/haproxy/haproxy.cfg.b

#disable firewall
service iptables stop
service ip6tables stop
setenforce 0
chkconfig iptables off
chkconfig ip6tables off
sed -i 's/SELINUX=permissive/SELINUX=disabled/g' /etc/sysconfig/selinux

#enable logging
cp /home/vagrant/files/haproxy.conf /etc/rsyslog.d/haproxy.conf
service rsyslog restart

#copy deployment files
cp /home/vagrant/files/haproxy.cfg /etc/haproxy/haproxy.cfg
sed -i "s/local_ip/${local_ip}/g" /etc/haproxy/haproxy.cfg
mkdir /etc/ssl/haproxy
cp /home/vagrant/files/tropicslocal.pem /etc/ssl/haproxy/tropicslocal.pem

#start service
service haproxy start

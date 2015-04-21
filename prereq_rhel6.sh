#!/usr/bin/env bash
yum -y install wget
if [ ! -f "/etc/yum.repos.d/devtools-2.repo" ]
        then
        cp  ~/mc-installer/repos/* /etc/yum.repos.d/
fi
if [ ! -f "/etc/yum.repos.d/scl.repo" ]
        then
        wget http://dev.centos.org/centos/6/SCL/scl.repo -P /etc/yum.repos.d/
fi

yum -y install libevent

if [ ! -f "libevent-devel-1.4.13-4.el6.x86_64.rpm" ]
        then
        wget http://mirror.centos.org/centos/6/os/x86_64/Packages/libevent-devel-1.4.13-4.el6.x86_64.rpm
fi
if [ ! -f "libevent-doc-1.4.13-4.el6.noarch.rpm" ]
        then
        wget http://mirror.centos.org/centos/6/os/x86_64/Packages/libevent-doc-1.4.13-4.el6.noarch.rpm
fi
if [ ! -f "libevent-headers-1.4.13-4.el6.noarch.rpm" ]
        then
        wget http://mirror.centos.org/centos/6/os/x86_64/Packages/libevent-headers-1.4.13-4.el6.noarch.rpm
fi
rpm -ivh *.rpm

rpm -Uvh http://sourceforge.net/projects/scons/files/scons/2.3.4/scons-2.3.4-1.noarch.rpm

yum -y install devtoolset-2-toolchain

scl enable devtoolset-2 bash 

mcrouter-installer
============

facebook mcrouter build for RHEL 6.2

The changes are mainly to allow for RHEL6.2 to download the versions of python27 and gcc4.8.x that are in the devtools-2 installation.

You will need to run the prereq_rhel6.sh to make sure you are running in devtools-2 mode. Remember to `exit` once you have finished the mcrouter build. You'll find it in /opt/mcrouter 

### Quick start guide:
```sh
yum install git
cd ~
git clone https://github.com/ConnectedHomes/mc-installer.git
./mc-installer/prereq_rhel6.sh
./mc-installer/full_install.sh
```

### If you want to run the cut down install
```scl enable python27 devtoolset-2 bash
./mc-installer/
```

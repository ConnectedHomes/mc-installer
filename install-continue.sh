#!/bin/bash
mkdir -p ~/rpmbuild/{BUILD,RPMS,SOURCES,SPECS,SRPMS}
cp ~/mc-installer/spec/* ~/rpmbuild/SPECS
cp ~/mc-installer/patch/* ~/rpmbuild/SOURCES
cd ~/rpmbuild/SOURCES
if [ ! -f "autoconf-2.69.tar.xz" ]
        then
        wget http://ftp.gnu.org.ua/gnu/autoconf/autoconf-2.69.tar.xz
fi
if [ ! -f "gflags-2.1.1.tar.gz" ]
        then
        wget http://github.com/schuhschuh/gflags/archive/v2.1.1/gflags-2.1.1.tar.gz
fi
if [ ! -f "glog-0.3.3.tar.gz" ]
        then
        wget http://github.com/google/glog/archive/v0.3.3/glog-0.3.3.tar.gz
fi
if [ ! -f "ragel-6.9.tar.gz" ]
        then
        wget http://www.colm.net/files/ragel/ragel-6.9.tar.gz
fi
rpmbuild -bb ~/rpmbuild/SPECS/autoconf.spec
rpmbuild -bb ~/rpmbuild/SPECS/gflags.spec
rpmbuild -bb ~/rpmbuild/SPECS/ragel.spec
cd ~/rpmbuild/RPMS/x86_64/
rpm -ivh gflags-2.1.1-6.el6.x86_64.rpm gflags-devel-2.1.1-6.el6.x86_64.rpm 
rpm -ivh ragel-6.9-2.3.x86_64.rpm
rpm -Uvh ~/rpmbuild/RPMS/noarch/autoconf-2.69-12.2.noarch.rpm
rpmbuild -bb ~/rpmbuild/SPECS/glog.spec
rpm -ivh glog-0.3.3-8.el6.x86_64.rpm glog-devel-0.3.3-8.el6.x86_64.rpm
cd /opt
git clone https://github.com/floitsch/double-conversion.git
cd double-conversion && scons install
ln -sf src double-conversion && scons -f SConstruct

echo '/usr/local/lib' >> /etc/ld.so.conf.d/libs.conf && ldconfig

cd /opt && git clone https://github.com/facebook/folly.git
export LD_LIBRARY_PATH="/opt/folly/folly/lib:$LD_LIBRARY_PATH"
export LD_RUN_PATH="/opt/folly/folly/lib"
export LDFLAGS="-L/opt/folly/folly/lib -L/opt/double-conversion -L/usr/local/lib -ldl"
export CPPFLAGS="-I/opt/folly/folly/include -I/opt/double-conversion"
cd /opt/folly/folly/ && autoreconf -ivf
./configure --with-boost-libdir=/usr/local/lib
make && make install
ldconfig
cd /opt/folly/folly/test
wget https://googletest.googlecode.com/files/gtest-1.7.0.zip
unzip gtest-1.7.0.zip

cd /opt && git clone https://github.com/facebook/mcrouter.git
cd mcrouter/mcrouter
export LD_LIBRARY_PATH="/opt/mcrouter/mcrouter/lib:/usr/local/lib:$LD_LIBRARY_PATH"
export LD_RUN_PATH="/opt/folly/folly/test/.libs:/opt/mcrouter/mcrouter/lib"
export LDFLAGS="-L/opt/mcrouter/mcrouter/lib -L/usr/local/lib -L/opt/folly/folly/test/.libs"
export CPPFLAGS="-I/opt/folly/folly/test/gtest-1.7.0/include -I/opt/mcrouter/mcrouter/include -I/opt/folly -I/opt/double-conversion -I/opt/fbthrift"
export CXXFLAGS="-fpermissive"
autoreconf -ivf && ./configure --with-boost-libdir=/usr/local/lib
make && make install
mcrouter --help

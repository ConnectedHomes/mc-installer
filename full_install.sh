#!/bin/bash
yum -y install unzip bzip2-devel libtool libcap-devel openssl-devel bison flex snappy-devel numactl-devel cyrus-sasl-devel boost-devel python-setuptools cmake transfig tetex-latex gcc-objc gcc rpm-build make gcc-c++ mpfr patch git redhat-rpm-config

# install boost
cd /usr/local/src
if [ ! -f "boost_1_55_0.tar.gz" ]
        then
        wget http://sourceforge.net/projects/boost/files/boost/1.55.0/boost_1_55_0.tar.gz/download -P /usr/local/src/ -O boost_1_55_0.tar.gz
        tar xvfvz boost_1_55_0.tar.gz
        cd boost_1_55_0
        ./bootstrap.sh --prefix=/usr/local --libdir=/usr/local/lib --with-libraries=program_options,context,filesystem,system,regex,thread,python
        ## Boost always fails to update everything, just ignore it. Boost, you are the worst :)
        set +e
        ./bjam -j4 --layout=system install
        set -e
        cd ..

        # boost 1.55 does not have thread-mt and regex-mt needed for folly, so emulate them
        ln -s /usr/local/lib/libboost_thread.so.1.55.0 /usr/local/lib/libboost_thread-mt.so
        ln -s /usr/local/lib/libboost_regex.so.1.55.0 /usr/local/lib/libboost_regex-mt.so
fi

# update ld config
ldconfig
# not sure that this line is correct but otherwise thrift1 will not be able to find libboost*.so in runtime
echo /usr/local/lib | sudo tee --append /etc/ld.so.conf > /dev/null

yum -y update
yum -y install python27
scl enable python27 "easy_install pip"
scl enable python27 ~/mc-installer/install-continue.sh


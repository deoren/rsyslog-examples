#!/bin/bash

# TODO: 
#
# - Add in lots of error handling, etc. Right now this is a copy/paste from the markdown doc.

# Used to determine whether yum or apt-get should be used to install packages
MATCH_REDHAT='Red Hat'
MATCH_UBUNTU='Ubuntu'
MATCH_CENTOS='CentOS'

apt_packages=(
  autoconf
  automake
  bison
  build-essential
  flex
  git-core
  libdbi-dev
  libgcrypt11-dev
  libgcrypt20-dev
  libglib2.0-dev
  libgnutls-dev
  libgrok-dev
  libgrok1
  libhiredis-dev
  libmongo-client-dev
  libmysqlclient-dev
  libnet1-dev
  libpcre3-dev
  libpq-dev
  librdkafka-dev
  libsystemd-dev
  libtokyocabinet-dev
  libtool
  pkg-config
  postgresql-client
  python-docutils
  uuid-dev
  valgrind
  zlib1g-dev
)

yum_packages=(

  autoconf
  automake
  bison
  flex
  git-core
  gnutls-devel
  libgcrypt-devel
  libtool
  libuuid-devel
  pcre-devel
  pkgconfig
  python-docutils
  systemd-devel
  valgrind
  zlib-devel

)

# Mash the contents into a single string - not creating an array via ()
RELEASE_INFO=$(cat /etc/*release)

if [[ "${RELEASE_INFO}" =~ ${MATCH_UBUNTU} ]]; then
    sudo apt-get -y install  "${apt_packages[@]}"
fi


# If CentOS or RedHat distro, looks for items specific to those distros
if [[ "${RELEASE_INFO}" =~ ${MATCH_CENTOS} ]] || 
    [[ "${RELEASE_INFO}" =~ ${MATCH_REDHAT} ]]
then
    sudo yum install -y  "${yum_packages[@]}"
fi


# FIXME: This needs to be abstracted
primary_test_conf_file="https://raw.githubusercontent.com/deoren/rsyslog-examples/master/github_issues/rsyslog-i2150-stock-Adiscon-repo.conf"

systemctl stop syslog.socket
systemctl stop rsyslog.service

cd /tmp
sudo rm -rf libfastjson libestr liblogging liblognorm librelp rsyslog

cd /tmp
git clone https://github.com/rsyslog/libfastjson
cd libfastjson/
sh autogen.sh CFLAGS="-g"
make
sudo make install

cd /tmp
git clone https://github.com/rsyslog/libestr
cd libestr
autoreconf -vfi
sh autogen.sh CFLAGS="-g" --enable-debug
make
sudo make install

cd /tmp
git clone https://github.com/rsyslog/liblogging
cd liblogging
sh autogen.sh CFLAGS="-g" --disable-man-pages
make
sudo make install

cd /tmp
git clone https://github.com/rsyslog/liblognorm
cd liblognorm
autoreconf -vfi
CFLAGS="-g" ./configure --disable-testbench --enable-valgrind --enable-tools --enable-debug --enable-regexp
make
sudo make install

cd /tmp
git clone https://github.com/rsyslog/librelp
cd librelp
autoreconf -vfi
./configure CFLAGS="-g" --enable-debug
make
sudo make install

cd /tmp
git clone https://github.com/rsyslog/rsyslog
cd rsyslog
sh autogen.sh CFLAGS="-g" LIBLOGNORM_CFLAGS="-I/tmp/liblognorm/src" LIBLOGNORM_LIBS="-L/usr/lib -llognorm" LIBLOGGING_STDLOG_LIBS="-L/usr/lib -llogging-stdlog" LIBLOGGING_STDLOG_CFLAGS="-I/tmp/liblogging" LIBFASTJSON_CFLAGS="-I/tmp/libfastjson" LIBFASTJSON_LIBS="-L/usr/lib -lfastjson" LIBESTR_CFLAGS="-I/tmp/libestr/include" LIBESTR_LIBS="-L/usr/lib -lestr" RELP_LIBS="-L/usr/lib" RELP_CFLAGS="-I/tmp/librelp/include" --disable-generate-man-pages --enable-liblogging-stdlog --enable-imfile --enable-imptcp --enable-impstats --enable-pmnormalize --enable-omuxsock --enable-mmjsonparse --enable-mail --enable-mmrm1stspace --enable-relp --enable-usertools --enable-imjournal --enable-valgrind
make
sudo make install
sudo ldconfig

# Should work equally well on Ubuntu 16.04 or CentOS 7
sudo systemctl --no-reload preset rsyslog
sudo systemctl daemon-reload

sudo wget ${primary_test_conf_file} -O /etc/rsyslog.conf

# Start rsyslog after all conf files have been dropped/modified/etc
sudo systemctl start syslog.socket
sudo systemctl start rsyslog.service

sudo systemctl status rsyslog -l

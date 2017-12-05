#!/bin/bash

# TODO: 
#
# - Add in lots of error handling, etc. Right now this is a copy/paste from the markdown doc.
# - Add in package installation commands specific to distro
# - Arrays of packages per distro ...

# FIXME: This needs to be abstracted
primary_test_conf_file="https://raw.githubusercontent.com/deoren/rsyslog-examples/master/github_issues/rsyslog-i2150-stock-Adiscon-repo.conf"

systemctl stop syslog.socket
systemctl stop rsyslog.service

cd /tmp
rm -rf libfastjson libestr liblogging liblognorm librelp rsyslog

cd /tmp
git clone https://github.com/rsyslog/libfastjson
cd libfastjson/
sh autogen.sh CFLAGS="-g"
make
sudo make install

cd /tmp
git clone https://github.com/rsyslog/libestr
cd libestr/
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
libtoolize --force
aclocal
autoheader
automake --force-missing --add-missing
autoconf
CFLAGS="-g" LIBESTR_CFLAGS="-I/tmp/libestr/include" LIBESTR_LIBS="-L/usr/lib" JSON_C_CFLAGS="-I/tmp/libfastjson" JSON_C_LIBS="-L/usr/lib -lfastjson" ./configure --disable-testbench --enable-valgrind --enable-tools --enable-debug --enable-regexp
make
sudo make install

cd /tmp
git clone https://github.com/rsyslog/librelp
cd librelp
libtoolize --force
aclocal
autoheader
automake --force-missing --add-missing
autoconf
./configure CFLAGS="-g" --enable-debug
make
sudo make install

cd /tmp
git clone https://github.com/rsyslog/rsyslog
cd rsyslog
sh autogen.sh CFLAGS="-g" LIBLOGGING_STDLOG_LIBS="-L/usr/lib -llogging-stdlog" LIBLOGGING_STDLOG_CFLAGS="-I/tmp/liblogging" LIBFASTJSON_CFLAGS="-I/tmp/libfastjson" LIBFASTJSON_LIBS="-L/usr/lib -lfastjson" LIBESTR_CFLAGS="-I/tmp/libestr/include" LIBESTR_LIBS="-L/usr/lib -lestr" RELP_LIBS="-L/usr/lib" RELP_CFLAGS="-I/tmp/librelp/include" --disable-generate-man-pages --enable-liblogging-stdlog --enable-imfile --enable-imptcp --enable-impstats --enable-pmnormalize --enable-omuxsock --enable-mmjsonparse --enable-mail --enable-mmrm1stspace --enable-relp --enable-usertools --enable-imjournal --enable-valgrind
make
sudo make install
sudo ldconfig

# Should work equally well on Ubuntu 16.04 or CentOS 7
systemctl --no-reload preset rsyslog
systemctl daemon-reload

wget ${primary_test_conf_file} -O /etc/rsyslog.conf

# Start rsyslog after all conf files have been dropped/modified/etc
systemctl start syslog.socket
systemctl start rsyslog.service

systemctl status rsyslog -l

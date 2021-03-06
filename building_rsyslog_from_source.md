# Building rsyslog from source

_Build rsyslog from source with maximum debug options enabled in order to aid in testing_

## Install required packages

### Ubuntu 16.04

1. `sudo apt-get update`
1. `sudo apt-get -y install autoconf automake bison build-essential flex git-core libdbi-dev libgcrypt11-dev libgcrypt20-dev libcurl4-gnutls-dev libglib2.0-dev libgnutls-dev libgrok-dev libgrok1 libhiredis-dev libmongo-client-dev libmysqlclient-dev libnet1-dev libpcre3-dev libpq-dev librdkafka-dev libsystemd-dev  libtokyocabinet-dev libtool pkg-config postgresql-client python-docutils uuid-dev valgrind zlib1g-dev`

### CentOS 7

1. `sudo yum install -y autoconf automake bison flex git-core gnutls-devel libcurl-devel libgcrypt-devel libtool libuuid-devel pcre-devel pkgconfig python-docutils systemd-devel valgrind zlib-devel`

Note: This list is incomplete and will need to be fleshed out further.

## Build dependencies

### Prune old downloads

Note: An alternate approach here is to checkout to clone the repos to a semi-permament location and then run `cd /path/to/repo; git clean -f -x` to clear out old build content

1. `cd /tmp`
1. `rm -rf libfastjson libestr liblogging liblognorm librelp rsyslog`

### libfastjson

1. `cd /tmp`
1. `git clone https://github.com/rsyslog/libfastjson`
1. `cd libfastjson/`
1. `sh autogen.sh CFLAGS="-g"`
1. `./configure CFLAGS="-g"`
1. `make`
1. `sudo make install`

### libestr

1. `cd /tmp`
1. `git clone https://github.com/rsyslog/libestr`
1. `cd libestr/`
1. `autoreconf -vfi`
1. `./configure CFLAGS="-g" --enable-debug`
1. `make`
1. `sudo make install`

### liglogging

1. `cd /tmp`
1. `git clone https://github.com/rsyslog/liblogging`
1. `cd liblogging`
1. `autoreconf -vfi`
1. `./configure CFLAGS="-g" --disable-man-pages`
1. `make`
1. `sudo make install`

### liblognorm

1. `cd /tmp`
1. `git clone https://github.com/rsyslog/liblognorm`
1. `cd liblognorm`
1. `autoreconf -vfi`
1. `./configure CFLAGS="-g" --disable-testbench --enable-valgrind --enable-tools --enable-debug --enable-regexp`
1. `make`
1. `sudo make install`

### librelp

1. `cd /tmp`
1. `git clone https://github.com/rsyslog/librelp`
1. `cd librelp`
1. `autoreconf -vfi`
1. `./configure CFLAGS="-g" --enable-debug`
1. `make`
1. `sudo make install`

## Build rsyslog

1. `cd /tmp`
1. `git clone https://github.com/rsyslog/rsyslog`
1. `cd rsyslog`
1. `sh autogen.sh CFLAGS="-g"`
1. `./configure CFLAGS="-g" --disable-generate-man-pages --enable-liblogging-stdlog --enable-imfile --enable-imptcp --enable-impstats --enable-pmnormalize --enable-omuxsock --enable-mmjsonparse --enable-mail --enable-mmrm1stspace --enable-relp --enable-usertools --enable-imjournal --enable-valgrind`
1. `make`

## Install rsyslog

1. `sudo make install`
1. `sudo ldconfig`
1. `systemctl --no-reload preset rsyslog`
1. `systemctl daemon-reload`
1. `systemctl restart rsyslog`
1. `systemctl status rsyslog`

## References

- https://github.com/rsyslog/rsyslog/issues/1920
- http://www.rsyslog.com/doc/build_from_repo.html
- https://github.com/rsyslog/rsyslog/issues/1839#issuecomment-346955531 (reference to CFLAGS build option)
- https://git.centos.org/blob/rpms!rsyslog.git/c7/SPECS!rsyslog.spec
- https://github.com/systemd/systemd/blob/master/src/core/macros.systemd.in
- https://askubuntu.com/questions/27677/cannot-find-install-sh-install-sh-or-shtool-in-ac-aux (help with building librelp)
- https://git-scm.com/docs/git-clean
- https://github.com/rsyslog/liblognorm/blob/master/doc/installation.rst
- https://github.com/rsyslog/libfastjson/blob/master/README.md
- https://github.com/rsyslog/rsyslog-docker/blob/master/dev_env/ubuntu/devel/setup-system.sh
- https://github.com/rsyslog/rsyslog-docker/blob/master/dev_env/centos7dev/Dockerfile
- https://github.com/rsyslog/rsyslog/blob/master/ChangeLog


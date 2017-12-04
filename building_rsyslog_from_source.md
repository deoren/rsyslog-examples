# Building rsyslog from source

_Build rsyslog from source with maximum debug options enabled in order to aid in testing_

## Install required packages

### Ubuntu 16.04

1. `sudo apt-get update`
1. `sudo apt-get -y install libtool autoconf automake git-core build-essential pkg-config zlib1g-dev uuid-dev libgcrypt20-dev libhiredis-dev uuid-dev libgcrypt11-dev flex bison libdbi-dev libmysqlclient-dev postgresql-client libpq-dev libnet-dev librdkafka-dev libgrok-dev libgrok1 libgrok-dev libpcre3-dev libtokyocabinet-dev libglib2.0-dev libmongo-client-dev python-docutils valgrind`

### CentOS 7

1. `sudo yum install -y libtool autoconf automake valgrind git-core flex bison python-docutils pkgconfig zlib-devel libuuid-devel systemd-devel libgcrypt-devel gnutls-devel pcre-devel`

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
1. `make`
1. `sudo make install`

### libestr

1. `cd /tmp`
1. `git clone https://github.com/rsyslog/libestr`
1. `cd libestr/`
1. `sh autogen.sh CFLAGS="-g" --enable-debug`
1. `make`
1. `sudo make install`

### liglogging

1. `cd /tmp`
1. `git clone https://github.com/rsyslog/liblogging`
1. `cd liblogging`
1. `sh autogen.sh CFLAGS="-g" --disable-man-pages`
1. `make`
1. `sudo make install`

### liblognorm

1. `cd /tmp`
1. `git clone https://github.com/rsyslog/liblognorm`
1. `cd liblognorm`
1. `libtoolize --force`
1. `aclocal`
1. `autoheader`
1. `automake --force-missing --add-missing`
1. `autoconf`
1. `CFLAGS="-g" LIBESTR_CFLAGS="-I/tmp/libestr/include" LIBESTR_LIBS="-L/usr/lib" JSON_C_CFLAGS="-I/tmp/libfastjson" JSON_C_LIBS="-L/usr/lib -lfastjson" ./configure --disable-testbench --enable-valgrind --enable-tools --enable-debug --enable-regexp`
1. `make`
1. `sudo make install`

### librelp

1. `cd /tmp`
1. `git clone https://github.com/rsyslog/librelp`
1. `cd librelp`
1. `libtoolize --force`
1. `aclocal`
1. `autoheader`
1. `automake --force-missing --add-missing`
1. `autoconf`
1. `./configure CFLAGS="-g" --enable-debug`
1. `make`
1. `sudo make install`

## Build rsyslog

1. `cd /tmp`
1. `git clone https://github.com/rsyslog/rsyslog`
1. `cd rsyslog`
1. `sh autogen.sh CFLAGS="-g" LIBLOGGING_STDLOG_LIBS="-L/usr/lib -llogging-stdlog" LIBLOGGING_STDLOG_CFLAGS="-I/tmp/liblogging" LIBFASTJSON_CFLAGS="-I/tmp/libfastjson" LIBFASTJSON_LIBS="-L/usr/lib -lfastjson" LIBESTR_CFLAGS="-I/tmp/libestr/include" LIBESTR_LIBS="-L/usr/lib -lestr" RELP_LIBS="-L/usr/lib" RELP_CFLAGS="-I/tmp/librelp/include"  --disable-generate-man-pages --enable-liblogging-stdlog --enable-imfile --enable-imptcp --enable-impstats --enable-pmnormalize --enable-omuxsock --enable-mmjsonparse --enable-mail --enable-mmrm1stspace --enable-relp --enable-usertools --enable-imjournal --enable-valgrind`
1. `make`
1. `sudo make install`
1. `sudo ldconfig`

## References

- https://github.com/rsyslog/rsyslog/issues/1920
- http://www.rsyslog.com/doc/build_from_repo.html
- https://github.com/rsyslog/rsyslog/issues/1839#issuecomment-346955531 (reference to CFLAGS build option)
- https://askubuntu.com/questions/27677/cannot-find-install-sh-install-sh-or-shtool-in-ac-aux (help with building librelp)
- https://git-scm.com/docs/git-clean

#!/bin/sh -eux

FILE_VERSION=5.39
NANO_VERSION=5.3

ARTIFACTS_DIR=$(realpath $(dirname ${0})/artifacts)

apk add gcc make groff linux-headers musl-dev ncurses-dev ncurses-static zlib-dev zlib-static

cd /tmp
wget http://ftp.astron.com/pub/file/file-${FILE_VERSION}.tar.gz -O - | tar zxvf -
cd file-${FILE_VERSION}
./configure --prefix=/usr CFLAGS="-Ofast" --enable-static
make -j8 install

cd /tmp
wget https://www.nano-editor.org/dist/v${NANO_VERSION%%.*}/nano-${NANO_VERSION}.tar.gz -O - | tar zxvf -
cd nano-${NANO_VERSION}
./configure --prefix=${ARTIFACTS_DIR}/nano-${NANO_VERSION} CFLAGS="-Ofast" LDFLAGS="-static -no-pie -s" LIBS="-lz"
make -j8 install

cd ${ARTIFACTS_DIR}
tar zcvf nano-${NANO_VERSION}.tar.gz nano-${NANO_VERSION}

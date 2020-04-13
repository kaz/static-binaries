#!/bin/sh -eux

FILE_VERSION=5.38
NANO_VERSION=4.9.2

apk add gcc make groff linux-headers musl-dev ncurses-dev ncurses-static zlib-dev zlib-static

cd /
wget ftp://ftp.astron.com/pub/file/file-${FILE_VERSION}.tar.gz -O - | tar zxvf -
cd file-${FILE_VERSION}
./configure --prefix=/usr CFLAGS="-Ofast" --enable-static
make -j8 install

cd /
wget https://www.nano-editor.org/dist/v4/nano-${NANO_VERSION}.tar.gz -O - | tar zxvf -
cd nano-${NANO_VERSION}
./configure --prefix=/build/artifacts/nano-${NANO_VERSION} CFLAGS="-Ofast" LDFLAGS="-static -no-pie -s" LIBS="-lz"
make -j8 install

cd /build/artifacts
tar zcvf nano-${NANO_VERSION}.tar.gz nano-${NANO_VERSION}

#!/bin/sh -eux

FILE_VERSION=5.40
NANO_VERSION=5.8

ARTIFACTS_DIR="$(realpath ./artifacts)"

readonly FILE_VERSION NANO_VERSION ARTIFACTS_DIR

apk add gcc groff linux-headers make musl-dev \
        ncurses-dev ncurses-static zlib-dev zlib-static

cd /tmp
wget -O- "http://ftp.astron.com/pub/file/file-${FILE_VERSION}.tar.gz" | tar zxvf -
cd "file-${FILE_VERSION}"
./configure --enable-static --prefix=/usr CFLAGS="-Ofast"
make -j8 install

cd /tmp
wget -O- "https://www.nano-editor.org/dist/v${NANO_VERSION%%.*}/nano-${NANO_VERSION}.tar.gz" \
     | tar zxvf -
cd "nano-${NANO_VERSION}"
./configure --prefix="${ARTIFACTS_DIR}/nano-${NANO_VERSION}" \
            CFLAGS="-Ofast" LDFLAGS="-static -no-pie -s" LIBS="-lz"
make -j8 install

cd "${ARTIFACTS_DIR}"
tar zcvf "nano-${NANO_VERSION}.tar.gz" "nano-${NANO_VERSION}"

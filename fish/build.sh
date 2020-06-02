#!/bin/sh -eux

FISH_VERSION=3.1.2

apk add gcc g++ make cmake musl-dev ncurses-dev ncurses-static

ln /usr/lib/libncursesw.a /usr/lib/libcurses.a

cd /
wget https://github.com/fish-shell/fish-shell/releases/download/${FISH_VERSION}/fish-${FISH_VERSION}.tar.gz -O - | tar zxvf -
cd fish-${FISH_VERSION}
cmake -DCMAKE_INSTALL_PREFIX=/build/artifacts/fish-${FISH_VERSION} -DCMAKE_C_FLAGS="-Ofast" -DCMAKE_CXX_FLAGS="-Ofast" -DCMAKE_EXE_LINKER_FLAGS="-static -no-pie -s" .
make -j8 install

cd /build/artifacts
tar zcvf fish-${FISH_VERSION}.tar.gz fish-${FISH_VERSION}

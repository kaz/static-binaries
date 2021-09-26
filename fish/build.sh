#!/bin/sh -eux

FISH_VERSION=3.2.2

ARTIFACTS_DIR="$(realpath ./artifacts)"

readonly FISH_VERSION ARTIFACTS_DIR

apk add cmake g++ gcc make musl-dev \
        ncurses-dev ncurses-static


ln -f /usr/lib/libncursesw.a /usr/lib/libcurses.a

cd /tmp
wget -O- "https://github.com/fish-shell/fish-shell/releases/download/${FISH_VERSION}/fish-${FISH_VERSION}.tar.xz" \
     | tar Jxvf -
cd "fish-${FISH_VERSION}"
cmake -DCMAKE_INSTALL_PREFIX="${ARTIFACTS_DIR}/fish-${FISH_VERSION}" \
      -DCMAKE_C_FLAGS="-Ofast" -DCMAKE_CXX_FLAGS="-Ofast" \
      -DCMAKE_EXE_LINKER_FLAGS="-static -no-pie -s" .
make -j8 install

cd "${ARTIFACTS_DIR}"
tar zcvf "fish-${FISH_VERSION}.tar.gz" "fish-${FISH_VERSION}"

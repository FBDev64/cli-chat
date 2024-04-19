#!/bin/bash
#

APP_VER="0.3"

BUILD_ARCH_AMD64="amd64"
BUILD_ARCH_ARM64="arm64"
BUILD_ARCH_ARM="arm"
BUILD_ARCH_x86="386"

OS_LINUX="linux"
OS_DARWIN="darwin"
OS_WINDOWS="windows"

BUILD_DIR="build"

BIN_NAME=${PWD##*/} # or just give a plain string here

touch "checksums_"$BIN_NAME"_"$APP_VER".txt"

for os in $OS_LINUX $OS_DARWIN $OS_WINDOWS
do
  for arch in $BUILD_ARCH_AMD64 $BUILD_ARCH_ARM64 $BUILD_ARCH_ARM $BUILD_ARCH_x86
  do
    echo "Building for $os $arch"
    if [ $os == "windows" ]; then
      GOOS=$os GOARCH=$arch go build -ldflags "-w -s" -o "$BIN_NAME".exe
      wait
      zip $BIN_NAME'_'$APP_VER'_'$os'_'$arch'.zip' $BIN_NAME".exe"
      sha256sum $BIN_NAME'_'$APP_VER'_'$os'_'$arch'.zip' >> "checksums_"$BIN_NAME"_"$APP_VER".txt"
      wait
      rm $BIN_NAME".exe"
    else 
      GOOS=$os GOARCH=$arch go build -ldflags "-w -s" -o "$BIN_NAME"
      wait
      tar cf $BIN_NAME'_'$APP_VER'_'$os'_'$arch'.tar' $BIN_NAME
      gzip $BIN_NAME'_'$APP_VER'_'$os'_'$arch'.tar'
      sha256sum $BIN_NAME'_'$APP_VER'_'$os'_'$arch'.tar.gz' >> "checksums_"$BIN_NAME"_"$APP_VER".txt"
      wait
      rm $BIN_NAME
    fi
    echo "Done."
  done
done

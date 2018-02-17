#!/bin/bash

print_usage()
{
  echo "Usage: $0 [--clean-only] || [<TARGET_ARCH_FULL> <TARGET_ARCH> <TARGET_ARCH_TOOLCHAIN_DIR> <TARGET_ARCH_BUILD_DIR> [--clean]]"
  echo "OPTIONS:"
  echo -e "\t*NO OPTION*\t: build only (make + make install)"
  echo -e "\t--clean\t\t: clean and configure before build"
  echo -e "\t--clean-only\t: clean without build"
  echo "Example: $0 arm-linux-androideabi arm /project/dependencies/toolchains/arm /project/dependencies/build/arm --clean"
}

usage()
{
  CLEAN_ONLY=false
  if (( $# == 1 )) && [[ "${1}" == "--clean-only" ]]; then
    CLEAN_ONLY=true
    return 0
  fi

  if (( $# != 4 )) && (( $# != 5 )); then
    print_usage
    exit 1
  fi

  TARGET_ARCH_FULL="${1}"
  TARGET_ARCH="${2}"
  TARGET_ARCH_TOOLCHAIN_DIR="$(readlink -f "${3}")"
  TARGET_ARCH_BUILD_DIR="$(readlink -f "${4}")"
  if [[ "${5}" == "--clean" ]]; then CLEAN=true; else CLEAN=false; fi
}

create_build_dir()
{
  mkdir -pv "${1}"
}

export_global_variables()
{
  export PATH="${PATH}:${TARGET_ARCH_TOOLCHAIN_DIR}/bin"
  export AR="${TARGET_ARCH_FULL}-ar"
  export AS="${TARGET_ARCH_FULL}-clang"
  export CC="${TARGET_ARCH_FULL}-clang"
  export CXX="${TARGET_ARCH_FULL}-clang++"
  export LD="${TARGET_ARCH_FULL}-ld"
  export STRIP="${TARGET_ARCH_FULL}-strip"
  export CFLAGS="-fPIE -fPIC -I${TARGET_ARCH_BUILD_DIR}/usr/include"
  export LDFLAGS="-pie -L${TARGET_ARCH_BUILD_DIR}/usr/lib"
}

git_reset()
{
  [ -e .git ] || (echo "'${PWD}': Not a git repository!" && exit 2)
  git clean -fdx && git reset --hard HEAD
  git checkout "${1}"
}

build()
{
  make -j8 VERBOSE=1
}

install()
{
  make -j8 VERBOSE=1 DESTDIR=/ install
}

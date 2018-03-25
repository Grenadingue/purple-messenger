#!/bin/bash

# NOTE: Useful link(s)
# http://www.xmlsoft.org/
# http://www.xmlsoft.org/news.html
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=libxml2-git

set -e

SCRIPT_DIR="$(dirname "$(readlink -f "${0}")")"
DEPENDENCY_DIR="${SCRIPT_DIR}/libxml2"
DEPENDENCY_CVS_REFERENCE=v2.9.8
BUILD_DIR="${4}"

source "${SCRIPT_DIR}/build_tools.sh"

configure()
{
  ./autogen.sh
  ./configure --disable-silent-rules \
    --prefix="${TARGET_ARCH_BUILD_DIR}/usr" \
    --libdir="${TARGET_ARCH_BUILD_DIR}/usr/lib" \
    --sysconfdir="${TARGET_ARCH_BUILD_DIR}/etc" \
    --host=${TARGET_ARCH_FULL} \
    --without-lzma \
    --without-python \
    --with-history
}

reset()
{
  cd "${DEPENDENCY_DIR}"
  git_reset "${DEPENDENCY_CVS_REFERENCE}"
}

usage "${@}"

if [[ "${CLEAN_ONLY}" == "true" ]]; then
  reset
  exit 0
fi

create_build_dir "${BUILD_DIR}"
export_global_variables

if [[ "${CLEAN}" == "true" ]]; then
  reset
  configure
fi

cd "${DEPENDENCY_DIR}"
build
install

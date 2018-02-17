#!/bin/bash

# NOTE: Useful link(s)
# https://sourceware.org/libffi/
# https://github.com/libffi/libffi
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=libffi-git

set -e

SCRIPT_DIR="$(dirname "$(readlink -f "${0}")")"
DEPENDENCY_DIR="${SCRIPT_DIR}/libffi"
DEPENDENCY_CVS_REFERENCE=master
BUILD_DIR="${4}"

source "${SCRIPT_DIR}/build_tools.sh"

configure()
{
  ./autogen.sh
  ./configure --disable-silent-rules \
    --prefix="${TARGET_ARCH_BUILD_DIR}/usr" \
    --libdir="${TARGET_ARCH_BUILD_DIR}/usr/lib" \
    --sysconfdir="${TARGET_ARCH_BUILD_DIR}/etc" \
    --host=${TARGET_ARCH_FULL}
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

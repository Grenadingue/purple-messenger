#!/bin/bash

# NOTE: Useful link(s)
# https://www.gnu.org/software/libidn/#downloading
# https://git.savannah.gnu.org/gitweb/?p=libidn.git;a=tree
# https://www.gnu.org/software/libidn/manual/libidn.html
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=libidn-git

set -e

SCRIPT_DIR="$(dirname "$(readlink -f "${0}")")"
DEPENDENCY_DIR="${SCRIPT_DIR}/libidn"
DEPENDENCY_CVS_REFERENCE=master
BUILD_DIR="${4}"

source "${SCRIPT_DIR}/build_tools.sh"

configure()
{
  make autoreconf
  ./configure --disable-silent-rules \
    --prefix="${TARGET_ARCH_BUILD_DIR}/usr" \
    --libdir="${TARGET_ARCH_BUILD_DIR}/usr/lib" \
    --sysconfdir="${TARGET_ARCH_BUILD_DIR}/etc" \
    --host=${TARGET_ARCH_FULL} \
    --disable-doc \
    --disable-java \
    --disable-csharp
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

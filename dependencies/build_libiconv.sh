#!/bin/bash

# NOTE: Useful link(s)
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=libiconv

set -e

SCRIPT_DIR="$(dirname "$(readlink -f "${0}")")"
DEPENDENCY_DIR="${SCRIPT_DIR}/libiconv"
DEFAULT_BRANCH_OR_TAG=v1.15
BUILD_DIR="${4}"

source "${SCRIPT_DIR}/build_tools.sh"

patch()
{
  git apply ../libiconv.patch
}

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
  cd "${SCRIPT_DIR}/gnulib"
  git_reset master
  cd "${DEPENDENCY_DIR}"
  git_reset "${DEFAULT_BRANCH_OR_TAG}"
}

usage "${@}"

if [[ "${CLEAN_ONLY}" == "true" ]]; then
  reset
  exit 0
fi

create_build_dir "${BUILD_DIR}"
export_global_variables

# NOTE: Quick and dirty workaround
ln -sf "$(which automake)" "${TARGET_ARCH_TOOLCHAIN_DIR}/bin/automake-1.15"
ln -sf "$(which autoconf)" "${TARGET_ARCH_TOOLCHAIN_DIR}/bin/autoconf-2.69"
ln -sf "$(which autoheader)" "${TARGET_ARCH_TOOLCHAIN_DIR}/bin/autoheader-2.69"

if [[ "${CLEAN}" == "true" ]]; then
  reset
  patch
  configure
fi

cd "${DEPENDENCY_DIR}"
build
install

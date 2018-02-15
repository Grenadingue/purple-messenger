#!/bin/bash

# NOTE: Useful link(s)
# https://savannah.gnu.org/projects/gettext
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=gettext-git

set -e

SCRIPT_DIR="$(dirname "$(readlink -f "${0}")")"
DEPENDENCY_DIR="${SCRIPT_DIR}/gettext"
DEPENDENCY_CVS_REFERENCE=v0.19.8.1
# NOTE: gnulib cvs reference retrieved from gettext/gnulib submodule reference
GNULIB_CVS_REFERENCE=6f9206d4db914cf904cd4711e3044d99c36dae8b
BUILD_DIR="${4}"

source "${SCRIPT_DIR}/build_tools.sh"

patch()
{
  # use existing gnulib submodule
  git apply ../libintl.patch
  # do not build man pages
  sed -i -e 's/ man//g' "${DEPENDENCY_DIR}/gettext-runtime/Makefile.am"
}

configure()
{
  ./autogen.sh
  cd "${DEPENDENCY_DIR}/gettext-runtime"
  ./configure --disable-silent-rules \
    --prefix="${TARGET_ARCH_BUILD_DIR}/usr" \
    --libdir="${TARGET_ARCH_BUILD_DIR}/usr/lib" \
    --sysconfdir="${TARGET_ARCH_BUILD_DIR}/etc" \
    --host=${TARGET_ARCH_FULL}
}

reset()
{
  cd "${SCRIPT_DIR}/gnulib"
  git_reset "${GNULIB_CVS_REFERENCE}"
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
  patch
  configure
fi

cd "${DEPENDENCY_DIR}/gettext-runtime"
build
install

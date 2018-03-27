#!/bin/bash

# NOTE: Useful link(s)
# https://wiki.gnome.org/Projects/JsonGlib
# https://gitlab.gnome.org/GNOME/json-glib/
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=libxml2-git

set -e

SCRIPT_DIR="$(dirname "$(readlink -f "${0}")")"
DEPENDENCY_DIR="${SCRIPT_DIR}/json-glib"
DEPENDENCY_CVS_REFERENCE=1.4.2
BUILD_DIR="${4}"

source "${SCRIPT_DIR}/build_tools.sh"

export_global_variables()
{
  export PATH="${TARGET_ARCH_BUILD_DIR}/usr/bin:${TARGET_ARCH_TOOLCHAIN_DIR}/bin:${PATH}"
  export PKG_CONFIG_LIBDIR="${TARGET_ARCH_BUILD_DIR}/usr/lib/pkgconfig"
  export PKG_CONFIG_SYSROOT_DIR=
  export PKG_CONFIG_DIR=
}

configure()
{
  ln -s "${SCRIPT_DIR}/meson_exe_wrapper.sh" exe_wrapper.sh

  cat << EOF > "${TARGET_ARCH_FULL}.txt"
[binaries]
c = '${TARGET_ARCH_FULL}-clang'
cpp = '${TARGET_ARCH_FULL}-clang++'
ar = '${TARGET_ARCH_FULL}-ar'
strip = '${TARGET_ARCH_FULL}-strip'
pkgconfig = '$(which pkg-config)'
exe_wrapper = '${DEPENDENCY_DIR}/exe_wrapper.sh'

[properties]
needs_exe_wrapper = true
c_args = ['-fPIE', '-fPIC', '-I${TARGET_ARCH_BUILD_DIR}/usr/include']
c_link_args = ['-pie', '-L${TARGET_ARCH_BUILD_DIR}/usr/lib']

[host_machine]
system = 'android'
cpu_family = '${TARGET_ARCH}'
cpu = '${TARGET_ARCH}'
endian = 'little'
EOF
  cat "${TARGET_ARCH_FULL}.txt"

  meson build \
    -Dintrospection=false \
    -Ddocs=false \
    --errorlogs \
    --cross-file "${TARGET_ARCH_FULL}.txt" \
    --prefix "${TARGET_ARCH_BUILD_DIR}/usr"
}

build()
{
  cd "${DEPENDENCY_DIR}/build"
  ninja -v
}

install()
{
  DESTDIR=/ ninja install
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

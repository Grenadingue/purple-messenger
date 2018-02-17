#!/bin/bash

# NOTE: Useful link(s)
# git://git.gnome.org/glib
# https://github.com/GNOME/glib
# https://developer.gnome.org/glib/
# https://developer.gnome.org/glib/stable/glib-cross-compiling.html
# https://marc.info/?l=gtk-devel&m=130087310901951&w=2
# http://gtk.10911.n7.nabble.com/Full-glib-porting-onto-Android-td29655.html
# https://zwyuan.github.io/2016/07/17/cross-compile-glib-for-android/
# https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=glib2-git

set -e

SCRIPT_DIR="$(dirname "$(readlink -f "${0}")")"
DEPENDENCY_DIR="${SCRIPT_DIR}/glib"
DEPENDENCY_CVS_REFERENCE=2.55.2
BUILD_DIR="${4}"

source "${SCRIPT_DIR}/build_tools.sh"

patch()
{
  git apply ../glib.patch
  cat << EOF > android.cache
glib_cv_long_long_format=ll
glib_cv_stack_grows=no
glib_cv_sane_realloc=yes
glib_cv_have_strlcpy=no
glib_cv_va_val_copy=yes
glib_cv_rtldglobal_broken=no
glib_cv_uscore=no
glib_cv_monotonic_clock=no
ac_cv_func_nonposix_getpwuid_r=no
ac_cv_func_posix_getpwuid_r=no
ac_cv_func_posix_getgrgid_r=no
glib_cv_use_pid_surrogate=yes
ac_cv_func_printf_unix98=no
ac_cv_func_vsnprintf_c99=yes
ac_cv_func_realloc_0_nonnull=yes
ac_cv_func_realloc_works=yes
EOF
  chmod 444 android.cache
}

configure()
{
  NOCONFIGURE=1 ./autogen.sh
  ./configure --disable-silent-rules \
    --prefix="${TARGET_ARCH_BUILD_DIR}/usr" \
    --libdir="${TARGET_ARCH_BUILD_DIR}/usr/lib" \
    --sysconfdir="${TARGET_ARCH_BUILD_DIR}/etc" \
    --with-pcre=internal \
    --disable-fam \
    --disable-libmount \
    --disable-libelf \
    --cache-file=android.cache \
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
  patch
  configure
fi

cd "${DEPENDENCY_DIR}"
build
install

# system environment variables
PATH_ORIG	=	$(PATH)

# android ndk location
ifndef ANDROID_NDK
  NDK_DEFAULT_VALUE=true
  ANDROID_NDK=$(HOME)/Android/Sdk/ndk-bundle
endif

# some system commands
RM	=	rm -rf
MKDIR	=	mkdir -pv

# some android commands
ANDROID_TOOLCHAIN_BUILDER	=	$(ANDROID_NDK)/build/tools/make-standalone-toolchain.sh

# target architectures
ARM	=	arm
ARM64	=	arm64
X86	=	x86
X86_64	=	x86_64

# target architectures compilers prefix
ARM_CC_PREFIX		=	arm-linux-androideabi
ARM64_CC_PREFIX		=	aarch64-linux-android
X86_CC_PREFIX		=	i686-linux-android
X86_64_CC_PREFIX	=	x86_64-linux-android

# project locations
PROJECT_ROOT_DIR	=	$(dir $(abspath $(lastword $(MAKEFILE_LIST))))
PROJECT_DEPENCIES_DIR	=	$(PROJECT_ROOT_DIR)dependencies

# toolchains locations
PROJECT_TOOLCHAINS_DIR	=	$(PROJECT_DEPENCIES_DIR)/toolchains
ARM_TOOLCHAIN_DIR	=	$(PROJECT_TOOLCHAINS_DIR)/$(ARM)
ARM64_TOOLCHAIN_DIR	=	$(PROJECT_TOOLCHAINS_DIR)/$(ARM64)
X86_TOOLCHAIN_DIR	=	$(PROJECT_TOOLCHAINS_DIR)/$(X86)
X86_64_TOOLCHAIN_DIR	=	$(PROJECT_TOOLCHAINS_DIR)/$(X86_64)

# build locations
PROJECT_BUILDS_DIR	=	$(PROJECT_DEPENCIES_DIR)/builds
ARM_BUILD_DIR		=	$(PROJECT_BUILDS_DIR)/$(ARM)
ARM64_BUILD_DIR		=	$(PROJECT_BUILDS_DIR)/$(ARM64)
X86_BUILD_DIR		=	$(PROJECT_BUILDS_DIR)/$(X86)
X86_64_BUILD_DIR	=	$(PROJECT_BUILDS_DIR)/$(X86_64)

# dependencies builders
LIBICONV_BUILDER	=	$(PROJECT_DEPENCIES_DIR)/build_libiconv.sh
LIBINTL_BUILDER		=	$(PROJECT_DEPENCIES_DIR)/build_libintl.sh
LIBFFI_BUILDER		=	$(PROJECT_DEPENCIES_DIR)/build_libffi.sh
PCRE_BUILDER		=	$(PROJECT_DEPENCIES_DIR)/build_pcre.sh
GLIB_BUILDER		=	$(PROJECT_DEPENCIES_DIR)/build_glib.sh
LIBXML_BUILDER		=	$(PROJECT_DEPENCIES_DIR)/build_libxml.sh
JSON_GLIB_BUILDER	=	$(PROJECT_DEPENCIES_DIR)/build_json_glib.sh
LIBIDN_BUILDER		=	$(PROJECT_DEPENCIES_DIR)/build_libidn.sh

# makefile rules
all: configure toolchains targets

configure:
	@if [ "$(NDK_DEFAULT_VALUE)" == "true" ]; then echo No ANDROID_NDK variable given, using default \"$(ANDROID_NDK)\"; fi
	@if [ ! -f "$(ANDROID_NDK)/ndk-build" ]; then echo Invalid ANDROID_NDK \"$(ANDROID_NDK)\" && false; fi
	@echo ANDROID_NDK = \"$(ANDROID_NDK)\"

toolchains: $(ARM_TOOLCHAIN_DIR) $(ARM64_TOOLCHAIN_DIR) $(X86_TOOLCHAIN_DIR) $(X86_64_TOOLCHAIN_DIR)

$(ARM_TOOLCHAIN_DIR):
	$(MKDIR) "$(PROJECT_TOOLCHAINS_DIR)"
	$(ANDROID_TOOLCHAIN_BUILDER) --verbose --arch=$(ARM) --install-dir="$(ARM_TOOLCHAIN_DIR)"

$(ARM64_TOOLCHAIN_DIR):
	$(MKDIR) "$(PROJECT_TOOLCHAINS_DIR)"
	$(ANDROID_TOOLCHAIN_BUILDER) --verbose --arch=$(ARM64) --install-dir="$(ARM64_TOOLCHAIN_DIR)"

$(X86_TOOLCHAIN_DIR):
	$(MKDIR) "$(PROJECT_TOOLCHAINS_DIR)"
	$(ANDROID_TOOLCHAIN_BUILDER) --verbose --arch=$(X86) --install-dir="$(X86_TOOLCHAIN_DIR)"

$(X86_64_TOOLCHAIN_DIR):
	$(MKDIR) "$(PROJECT_TOOLCHAINS_DIR)"
	$(ANDROID_TOOLCHAIN_BUILDER) --verbose --arch=$(X86_64) --install-dir="$(X86_64_TOOLCHAIN_DIR)"

clean_toolchains:
	$(RM) "$(PROJECT_TOOLCHAINS_DIR)"

# targets build
targets: $(ARM) $(ARM64) $(X86) $(X86_64)

define define_build_targets_rule
$(1):   \
	$(1)_libiconv \
	$(1)_libintl \
	$(1)_libffi \
	$(1)_pcre \
	$(1)_glib \
	$(1)_libxml \
	$(1)_json_glib \
	$(1)_libidn
endef

$(eval $(call define_build_targets_rule,$(ARM)))
$(eval $(call define_build_targets_rule,$(ARM64)))
$(eval $(call define_build_targets_rule,$(X86)))
$(eval $(call define_build_targets_rule,$(X86_64)))

## libiconv build
$(ARM)_libiconv:
	$(MKDIR) "$(ARM_BUILD_DIR)"
	$(LIBICONV_BUILDER) $(ARM_CC_PREFIX) $(ARM) "$(ARM_TOOLCHAIN_DIR)" "$(ARM_BUILD_DIR)" --clean

$(ARM64)_libiconv:
	$(MKDIR) "$(ARM64_TOOLCHAIN_DIR)"
	$(LIBICONV_BUILDER) $(ARM64_CC_PREFIX) $(ARM64) "$(ARM64_TOOLCHAIN_DIR)" "$(ARM64_BUILD_DIR)" --clean

$(X86)_libiconv:
	$(MKDIR) "$(X86_TOOLCHAIN_DIR)"
	$(LIBICONV_BUILDER) $(X86_CC_PREFIX) $(X86) "$(X86_TOOLCHAIN_DIR)" "$(X86_BUILD_DIR)" --clean

$(X86_64)_libiconv:
	$(MKDIR) "$(X86_64_TOOLCHAIN_DIR)"
	$(LIBICONV_BUILDER) $(X86_64_CC_PREFIX) $(X86_64) "$(X86_64_TOOLCHAIN_DIR)" "$(X86_64_BUILD_DIR)" --clean

## libintl build
$(ARM)_libintl:
	$(LIBINTL_BUILDER) $(ARM_CC_PREFIX) $(ARM) "$(ARM_TOOLCHAIN_DIR)" "$(ARM_BUILD_DIR)" --clean

$(ARM64)_libintl:
	$(LIBINTL_BUILDER) $(ARM64_CC_PREFIX) $(ARM64) "$(ARM64_TOOLCHAIN_DIR)" "$(ARM64_BUILD_DIR)" --clean

$(X86)_libintl:
	$(LIBINTL_BUILDER) $(X86_CC_PREFIX) $(X86) "$(X86_TOOLCHAIN_DIR)" "$(X86_BUILD_DIR)" --clean

$(X86_64)_libintl:
	$(LIBINTL_BUILDER) $(X86_64_CC_PREFIX) $(X86_64) "$(X86_64_TOOLCHAIN_DIR)" "$(X86_64_BUILD_DIR)" --clean

## libffi build
$(ARM)_libffi:
	$(LIBFFI_BUILDER) $(ARM_CC_PREFIX) $(ARM) "$(ARM_TOOLCHAIN_DIR)" "$(ARM_BUILD_DIR)" --clean

$(ARM64)_libffi:
	$(LIBFFI_BUILDER) $(ARM64_CC_PREFIX) $(ARM64) "$(ARM64_TOOLCHAIN_DIR)" "$(ARM64_BUILD_DIR)" --clean

$(X86)_libffi:
	$(LIBFFI_BUILDER) $(X86_CC_PREFIX) $(X86) "$(X86_TOOLCHAIN_DIR)" "$(X86_BUILD_DIR)" --clean

$(X86_64)_libffi:
	$(LIBFFI_BUILDER) $(X86_64_CC_PREFIX) $(X86_64) "$(X86_64_TOOLCHAIN_DIR)" "$(X86_64_BUILD_DIR)" --clean

## pcre build
$(ARM)_pcre:
	$(PCRE_BUILDER) $(ARM_CC_PREFIX) $(ARM) "$(ARM_TOOLCHAIN_DIR)" "$(ARM_BUILD_DIR)" --clean

$(ARM64)_pcre:
	$(PCRE_BUILDER) $(ARM64_CC_PREFIX) $(ARM64) "$(ARM64_TOOLCHAIN_DIR)" "$(ARM64_BUILD_DIR)" --clean

$(X86)_pcre:
	$(PCRE_BUILDER) $(X86_CC_PREFIX) $(X86) "$(X86_TOOLCHAIN_DIR)" "$(X86_BUILD_DIR)" --clean

$(X86_64)_pcre:
	$(PCRE_BUILDER) $(X86_64_CC_PREFIX) $(X86_64) "$(X86_64_TOOLCHAIN_DIR)" "$(X86_64_BUILD_DIR)" --clean

## glib build
$(ARM)_glib:
	$(GLIB_BUILDER) $(ARM_CC_PREFIX) $(ARM) "$(ARM_TOOLCHAIN_DIR)" "$(ARM_BUILD_DIR)" --clean

$(ARM64)_glib:
	$(GLIB_BUILDER) $(ARM64_CC_PREFIX) $(ARM64) "$(ARM64_TOOLCHAIN_DIR)" "$(ARM64_BUILD_DIR)" --clean

$(X86)_glib:
	$(GLIB_BUILDER) $(X86_CC_PREFIX) $(X86) "$(X86_TOOLCHAIN_DIR)" "$(X86_BUILD_DIR)" --clean

$(X86_64)_glib:
	$(GLIB_BUILDER) $(X86_64_CC_PREFIX) $(X86_64) "$(X86_64_TOOLCHAIN_DIR)" "$(X86_64_BUILD_DIR)" --clean

## libxml build
$(ARM)_libxml:
	$(LIBXML_BUILDER) $(ARM_CC_PREFIX) $(ARM) "$(ARM_TOOLCHAIN_DIR)" "$(ARM_BUILD_DIR)" --clean

$(ARM64)_libxml:
	$(LIBXML_BUILDER) $(ARM64_CC_PREFIX) $(ARM64) "$(ARM64_TOOLCHAIN_DIR)" "$(ARM64_BUILD_DIR)" --clean

$(X86)_libxml:
	$(LIBXML_BUILDER) $(X86_CC_PREFIX) $(X86) "$(X86_TOOLCHAIN_DIR)" "$(X86_BUILD_DIR)" --clean

$(X86_64)_libxml:
	$(LIBXML_BUILDER) $(X86_64_CC_PREFIX) $(X86_64) "$(X86_64_TOOLCHAIN_DIR)" "$(X86_64_BUILD_DIR)" --clean

## json_glib build
$(ARM)_json_glib:
	$(JSON_GLIB_BUILDER) $(ARM_CC_PREFIX) $(ARM) "$(ARM_TOOLCHAIN_DIR)" "$(ARM_BUILD_DIR)" --clean

$(ARM64)_json_glib:
	$(JSON_GLIB_BUILDER) $(ARM64_CC_PREFIX) $(ARM64) "$(ARM64_TOOLCHAIN_DIR)" "$(ARM64_BUILD_DIR)" --clean

$(X86)_json_glib:
	$(JSON_GLIB_BUILDER) $(X86_CC_PREFIX) $(X86) "$(X86_TOOLCHAIN_DIR)" "$(X86_BUILD_DIR)" --clean

$(X86_64)_json_glib:
	$(JSON_GLIB_BUILDER) $(X86_64_CC_PREFIX) $(X86_64) "$(X86_64_TOOLCHAIN_DIR)" "$(X86_64_BUILD_DIR)" --clean

## libidn build
$(ARM)_libidn:
	$(LIBIDN_BUILDER) $(ARM_CC_PREFIX) $(ARM) "$(ARM_TOOLCHAIN_DIR)" "$(ARM_BUILD_DIR)" --clean

$(ARM64)_libidn:
	$(LIBIDN_BUILDER) $(ARM64_CC_PREFIX) $(ARM64) "$(ARM64_TOOLCHAIN_DIR)" "$(ARM64_BUILD_DIR)" --clean

$(X86)_libidn:
	$(LIBIDN_BUILDER) $(X86_CC_PREFIX) $(X86) "$(X86_TOOLCHAIN_DIR)" "$(X86_BUILD_DIR)" --clean

$(X86_64)_libidn:
	$(LIBIDN_BUILDER) $(X86_64_CC_PREFIX) $(X86_64) "$(X86_64_TOOLCHAIN_DIR)" "$(X86_64_BUILD_DIR)" --clean

## clean
clean_targets: clean_$(ARM) clean_$(ARM64) clean_$(X86) clean_$(X86_64)

clean_$(ARM): clean_repositories
	$(RM) "$(ARM_BUILD_DIR)"

clean_$(ARM64): clean_repositories
	$(RM) "$(ARM64_BUILD_DIR)"

clean_$(X86): clean_repositories
	$(RM) "$(X86_BUILD_DIR)"

clean_$(X86_64): clean_repositories
	$(RM) "$(X86_64_BUILD_DIR)"

clean_repositories: \
	clean_libiconv \
	clean_libintl \
	clean_libffi \
	clean_pcre \
	clean_glib \
	clean_libxml \
	clean_json_glib \
	clean_libidn

clean_libiconv:
	$(LIBICONV_BUILDER) --clean-only

clean_libintl:
	$(LIBINTL_BUILDER) --clean-only

clean_libffi:
	$(LIBFFI_BUILDER) --clean-only

clean_pcre:
	$(PCRE_BUILDER) --clean-only

clean_glib:
	$(GLIB_BUILDER) --clean-only

clean_libxml:
	$(LIBXML_BUILDER) --clean-only

clean_json_glib:
	$(JSON_GLIB_BUILDER) --clean-only

clean_libidn:
	$(LIBIDN_BUILDER) --clean-only

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
PROJECT_DEPENCIES_DIR	=	$(PROJECT_ROOT_DIR)/dependencies

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


$(ARM): $(ARM)_libiconv $(ARM)_libintl

$(ARM64): $(ARM64)_libiconv $(ARM64)_libintl

$(X86): $(X86)_libiconv $(X86)_libintl

$(X86_64): $(X86_64)_libiconv $(X86_64)_libintl

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

## clean
clean_targets: clean_$(ARM) clean_$(ARM64) clean_$(X86) clean_$(X86_64)

clean_$(ARM): clean_libiconv clean_libintl
	$(RM) "$(ARM_BUILD_DIR)"

clean_$(ARM64): clean_libiconv clean_libintl
	$(RM) "$(ARM64_BUILD_DIR)"

clean_$(X86): clean_libiconv clean_libintl
	$(RM) "$(X86_BUILD_DIR)"

clean_$(X86_64): clean_libiconv clean_libintl
	$(RM) "$(X86_64_BUILD_DIR)"

clean_libiconv:
	$(LIBICONV_BUILDER) --clean-only

clean_libintl:
	$(LIBINTL_BUILDER) --clean-only

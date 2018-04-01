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
define define_dependency_builder
$(shell echo $(1)_BUILDER | tr a-z A-Z)	=	$(PROJECT_DEPENCIES_DIR)/build_$(1).sh
endef

$(eval $(call define_dependency_builder,libiconv))
$(eval $(call define_dependency_builder,libintl))
$(eval $(call define_dependency_builder,libffi))
$(eval $(call define_dependency_builder,pcre))
$(eval $(call define_dependency_builder,glib))
$(eval $(call define_dependency_builder,libxml))
$(eval $(call define_dependency_builder,json_glib))
$(eval $(call define_dependency_builder,libidn))

# makefile rules
all: configure toolchains targets

configure:
	@if [ "$(NDK_DEFAULT_VALUE)" == "true" ]; then echo No ANDROID_NDK variable given, using default \"$(ANDROID_NDK)\"; fi
	@if [ ! -f "$(ANDROID_NDK)/ndk-build" ]; then echo Invalid ANDROID_NDK \"$(ANDROID_NDK)\" && false; fi
	@echo ANDROID_NDK = \"$(ANDROID_NDK)\"

toolchains: $(ARM_TOOLCHAIN_DIR) $(ARM64_TOOLCHAIN_DIR) $(X86_TOOLCHAIN_DIR) $(X86_64_TOOLCHAIN_DIR)

define define_create_toolchain_rule
$(2):
	$(MKDIR) "$(PROJECT_TOOLCHAINS_DIR)"
	$(ANDROID_TOOLCHAIN_BUILDER) --verbose --arch=$(1) --install-dir="$(2)"
endef

$(eval $(call define_create_toolchain_rule,$(ARM),$(ARM_TOOLCHAIN_DIR)))
$(eval $(call define_create_toolchain_rule,$(ARM64),$(ARM64_TOOLCHAIN_DIR)))
$(eval $(call define_create_toolchain_rule,$(X86),$(X86_TOOLCHAIN_DIR)))
$(eval $(call define_create_toolchain_rule,$(X86_64),$(X86_64_TOOLCHAIN_DIR)))

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

define define_build_target_rules
$(ARM)_$(1):
	$(MKDIR) "$(ARM_BUILD_DIR)"
	$(2) $(ARM_CC_PREFIX) $(ARM) "$(ARM_TOOLCHAIN_DIR)" "$(ARM_BUILD_DIR)" --clean

$(ARM64)_$(1):
	$(MKDIR) "$(ARM64_TOOLCHAIN_DIR)"
	$(2) $(ARM64_CC_PREFIX) $(ARM64) "$(ARM64_TOOLCHAIN_DIR)" "$(ARM64_BUILD_DIR)" --clean

$(X86)_$(1):
	$(MKDIR) "$(X86_TOOLCHAIN_DIR)"
	$(2) $(X86_CC_PREFIX) $(X86) "$(X86_TOOLCHAIN_DIR)" "$(X86_BUILD_DIR)" --clean

$(X86_64)_$(1):
	$(MKDIR) "$(X86_64_TOOLCHAIN_DIR)"
	$(2) $(X86_64_CC_PREFIX) $(X86_64) "$(X86_64_TOOLCHAIN_DIR)" "$(X86_64_BUILD_DIR)" --clean
endef

$(eval $(call define_build_target_rules,libiconv,$(LIBICONV_BUILDER)))
$(eval $(call define_build_target_rules,libintl,$(LIBINTL_BUILDER)))
$(eval $(call define_build_target_rules,libffi,$(LIBFFI_BUILDER)))
$(eval $(call define_build_target_rules,pcre,$(PCRE_BUILDER)))
$(eval $(call define_build_target_rules,glib,$(GLIB_BUILDER)))
$(eval $(call define_build_target_rules,libxml,$(LIBXML_BUILDER)))
$(eval $(call define_build_target_rules,json_glib,$(JSON_GLIB_BUILDER)))
$(eval $(call define_build_target_rules,libidn,$(LIBIDN_BUILDER)))

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

define define_clean_target_rule
clean_$(1):
	$(2) --clean-only
endef

$(eval $(call define_clean_target_rule,libiconv,$(LIBICONV_BUILDER)))
$(eval $(call define_clean_target_rule,libintl,$(LIBINTL_BUILDER)))
$(eval $(call define_clean_target_rule,libffi,$(LIBFFI_BUILDER)))
$(eval $(call define_clean_target_rule,pcre,$(PCRE_BUILDER)))
$(eval $(call define_clean_target_rule,glib,$(GLIB_BUILDER)))
$(eval $(call define_clean_target_rule,libxml,$(LIBXML_BUILDER)))
$(eval $(call define_clean_target_rule,json_glib,$(JSON_GLIB_BUILDER)))
$(eval $(call define_clean_target_rule,libidn,$(LIBIDN_BUILDER)))

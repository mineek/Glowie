before-package::
	python3 abi.py $(THEOS_OBJ_DIR)/arm64e/*.dylib

TARGET := iphone:clang:13.0
PREFIX = $(THEOS)/toolchain/linux/usr/bin/
SYSROOT = $(THEOS)/sdks/iPhoneOS13.7.sdk
INSTALL_TARGET_PROCESSES = SpringBoard
THEOS_PACKAGE_SCHEME = rootless


include $(THEOS)/makefiles/common.mk


TWEAK_NAME = Glow

Glow_FILES = $(wildcard *.x)
Glow_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
# SUBPROJECTS += Glowprefs
# include $(THEOS_MAKE_PATH)/aggregate.mk

# before-package::
# 	python3 abi.py $(THEOS_OBJ_DIR)/arm64e/*.dylib

# TARGET = simulator:clang:latest:13.0
TARGET := iphone:clang:13.0
PREFIX = $(THEOS)/toolchain/Xcode.xctoolchain/usr/bin/
SYSROOT = $(THEOS)/sdks/iPhoneOS14.5.sdk
INSTALL_TARGET_PROCESSES = SpringBoard
# THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk


TWEAK_NAME = Glow

Glow_FILES = $(wildcard *.x)
Glow_LIBRARIES = colorpicker
Glow_CFLAGS = -fobjc-arc
Glow_EXTRA_FRAMEWORKS += Cephei Alderis

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += glowprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

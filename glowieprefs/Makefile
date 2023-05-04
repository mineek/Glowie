TARGET := iphone:clang:14.5:14.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = glowieprefs

glowieprefs_FILES = GLOWRootListController.m
glowieprefs_FRAMEWORKS = UIKit
glowieprefs_PRIVATE_FRAMEWORKS = Preferences
glowieprefs_INSTALL_PATH = /Library/PreferenceBundles
glowieprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

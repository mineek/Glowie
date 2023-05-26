TARGET := iphone:clang:14.5:14.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = Glowprefs

Glowprefs_FILES = GLOWRootListController.m
Glowprefs_FRAMEWORKS = UIKit
Glowprefs_PRIVATE_FRAMEWORKS = Preferences
Glowprefs_INSTALL_PATH = /Library/PreferenceBundles
Glowprefs_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

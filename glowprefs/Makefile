TARGET := iphone:clang:14.5:12.0
THEOS_PACKAGE_SCHEME = rootless

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = glowprefs

glowprefs_FILES = GLOWRootListController.m
glowprefs_FRAMEWORKS = UIKit
glowprefs_PRIVATE_FRAMEWORKS = Preferences
glowprefs_INSTALL_PATH = /Library/PreferenceBundles
glowprefs_CFLAGS = -fobjc-arc
# glowprefs_LIBRARIES = colorpicker
# glowprefs_EXTRA_FRAMEWORKS = Cephei CepheiPrefs Alderis

include $(THEOS_MAKE_PATH)/bundle.mk

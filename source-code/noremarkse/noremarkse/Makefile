ARCHS = arm64
TARGET = iphone:clang:11.2:latest

include $(THEOS)/makefiles/common.mk

BUNDLE_NAME = NoRemarkse

NoRemarkse_FILES = NRRootListController.m
NoRemarkse_INSTALL_PATH = /Library/PreferenceBundles
NoRemarkse_FRAMEWORKS = UIKit
NoRemarkse_PRIVATE_FRAMEWORKS = Preferences
NoRemarkse_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/bundle.mk

internal-stage::
	$(ECHO_NOTHING)mkdir -p $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences$(ECHO_END)
	$(ECHO_NOTHING)cp entry.plist $(THEOS_STAGING_DIR)/Library/PreferenceLoader/Preferences/NoRemarkse.plist$(ECHO_END)

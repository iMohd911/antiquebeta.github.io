ARCHS = arm64
FOR_RELEASE = 1
TARGET = iphone:clang:11.2:latest
INSTALL_TARGET_PROCESSES = Cydia

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = NoRemarkse
NoRemarkse_FILES = Tweak.x
NoRemarkse_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk
SUBPROJECTS += noremarkse
include $(THEOS_MAKE_PATH)/aggregate.mk

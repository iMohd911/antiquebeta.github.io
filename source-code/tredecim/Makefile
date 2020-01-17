ARCHS = arm64
TARGET = iphone:clang:9.2:latest
DEBUG = 0

INSTALL_TARGET_PROCESSES = SpringBoard

include $(THEOS)/makefiles/common.mk

TWEAK_NAME = Tredecim
Tredecim_FILES = Tweak.x $(wildcard Classes/*.m)
Tredecim_CFLAGS = -fobjc-arc

include $(THEOS_MAKE_PATH)/tweak.mk

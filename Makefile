include theos/makefiles/common.mk

TWEAK_NAME = TelegramPlayback
TelegramPlayback_FILES = Tweak.xm

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += telegramplaybackprefs
include $(THEOS_MAKE_PATH)/aggregate.mk

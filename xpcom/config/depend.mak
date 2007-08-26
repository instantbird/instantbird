# temporary hack until I figure out what I should do with mkdepend

src/purpleCoreService.o: src/purpleCoreService.cpp src/purpleCoreService.h
src/purpleCoreService.h: src/purpleICoreService.h src/purpleIConversation.h src/purpleIProtocol.h src/purpleIPref.h src/purpleIAccount.h src/purpleIBuddy.h

src/purpleConversation.o: src/purpleConversation.cpp src/purpleConversation.h
src/purpleConversation.h: src/purpleIConversation.h

src/purplePref.o: src/purplePref.h
src/purplePref.h: src/purpleIPref.h

src/purpleAccount.o: src/purpleAccount.h
src/purpleAccount.h: src/purpleIAccount.h

src/purpleBuddy.o: src/purpleBuddy.h
src/purpleBuddy.h: src/purpleIBuddy.h

src/purpleMessage.o: src/purpleMessage.h
src/purpleMessage.h: src/purpleIMessage.h

src/purpleModule.o: src/purpleCoreService.o src/purpleMessage.h

src/purpleTimer.o: src/purpleTimer.h

OBJS += \
    src/purpleModule.o \
    src/purpleCoreService.o \
    src/purpleConversation.o \
    src/purpleProtocol.o \
    src/purplePref.o \
    src/purpleAccount.o \
    src/purpleUtils.o \
    src/purpleLoader.o \
    src/purpleInit.o \
    src/purpleBuddy.o \
    src/purpleMessage.o \
    src/purpleTimer.o \
    libpurple.$(DYLIB_SUFFIX) \
    $(call EXPAND_DLLNAME,purpleloader) \
    $(call EXPAND_DLLNAME,purplexpcom) purplexpcom.xpt \
    public/purpleICoreService.xpt src/purpleICoreService.h \
    public/purpleIConversation.xpt src/purpleIConversation.h \
    public/purpleIProtocol.xpt src/purpleIProtocol.h \
    public/purpleIPref.xpt src/purpleIPref.h \
    public/purpleIAccount.xpt src/purpleIAccount.h \
    public/purpleIBuddy.xpt src/purpleIBuddy.h \
    public/purpleIMessage.xpt src/purpleIMessage.h \
    $(NULL)

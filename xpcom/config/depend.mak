# temporary hack until I figure out what I should do with mkdepend

src/purpleCoreService.o: src/purpleCoreService.cpp src/purpleCoreService.h
src/purpleCoreService.h: src/purpleICoreService.h src/purpleIConversation.h src/purpleIProtocol.h src/purpleIPref.h src/purpleIAccount.h

src/purpleConversation.o: src/purpleConversation.cpp src/purpleConversation.h
src/purpleConversation.h: src/purpleIConversation.h

src/purplePref.o: src/purplePref.h
src/purplePref.h: src/purpleIPref.h

src/purpleAccount.o: src/purpleAccount.h
src/purpleAccount.h: src/purpleIAccount.h

src/purpleModule.o: src/purpleCoreService.o

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
    libpurple.$(DYLIB_SUFFIX) \
    $(call EXPAND_DLLNAME,purpleloader) \
    $(call EXPAND_DLLNAME,purplexpcom) purplexpcom.xpt \
    public/purpleICoreService.xpt src/purpleICoreService.h \
    public/purpleIConversation.xpt src/purpleIConversation.h \
    public/purpleIProtocol.xpt src/purpleIProtocol.h \
    public/purpleIPref.xpt src/purpleIPref.h \
    public/purpleIAccount.xpt src/purpleIAccount.h \
    $(NULL)

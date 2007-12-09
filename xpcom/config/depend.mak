# temporary hack until I figure out what I should do with mkdepend

src/purpleCoreService.o: src/purpleCoreService.cpp src/purpleCoreService.h
src/purpleCoreService.h: src/purpleICoreService.h src/purpleIConversation.h src/purpleIProtocol.h src/purpleIPref.h src/purpleIAccount.h src/purpleBuddy.h src/purpleSockets.h

src/purpleConversation.o: src/purpleConversation.cpp src/purpleConversation.h
src/purpleConversation.h: src/purpleIConversation.h

src/purplePref.o: src/purplePref.h
src/purplePref.h: src/purpleIPref.h

src/purpleAccount.o: src/purpleAccount.h
src/purpleAccount.h: src/purpleIAccount.h

src/purpleBuddy.o: src/purpleBuddy.h
src/purpleBuddy.h: src/purpleIBuddy.h src/purpleAccountBuddy.h

src/purpleTag.o: src/purpleTag.h
src/purpleTag.h: src/purpleITag.h

src/purpleAccountBuddy.o: src/purpleAccountBuddy.h
src/purpleAccountBuddy.h: src/purpleIAccountBuddy.h src/purpleITag.h

src/purpleMessage.o: src/purpleMessage.h
src/purpleMessage.h: src/purpleIMessage.h

src/purpleSockets.o: src/purpleSockets.h
src/purpleSockets.h: src/purpleISocket.h

src/purpleModule.o: src/purpleCoreService.o src/purpleMessage.h src/purpleSockets.h src/purpleTag.h src/purpleAccountBuddy.h

src/purpleTimer.o: src/purpleTimer.h

src/purpleStorage.o: src/purpleStorage.h

src/purpleDNS.o: src/purpleDNS.h

OBJS += \
    src/purpleModule.o \
    src/purpleCoreService.o \
    src/purpleConversation.o \
    src/purpleProtocol.o \
    src/purplePref.o \
    src/purpleAccount.o \
    src/purpleLoader.o \
    src/purpleInit.o \
    src/purpleBuddy.o \
    src/purpleTag.o \
    src/purpleAccountBuddy.o \
    src/purpleMessage.o \
    src/purpleTimer.o \
    src/purpleSockets.o \
    src/purpleDNS.o \
    src/purpleStorage.o \
    libpurple.$(DYLIB_SUFFIX) \
    $(call EXPAND_DLLNAME,purpleloader) \
    $(call EXPAND_DLLNAME,purplexpcom) purplexpcom.xpt \
    public/purpleICoreService.xpt src/purpleICoreService.h \
    public/purpleIConversation.xpt src/purpleIConversation.h \
    public/purpleIProtocol.xpt src/purpleIProtocol.h \
    public/purpleIPref.xpt src/purpleIPref.h \
    public/purpleIAccount.xpt src/purpleIAccount.h \
    public/purpleIBuddy.xpt src/purpleIBuddy.h \
    public/purpleITag.xpt src/purpleITag.h \
    public/purpleIAccountBuddy.xpt src/purpleIAccountBuddy.h \
    public/purpleIMessage.xpt src/purpleIMessage.h \
    public/purpleISocket.xpt src/purpleISocket.h \
    $(NULL)

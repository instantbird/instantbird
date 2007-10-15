all:

-include config/config.mak
-include config/rules.mak

all: \
	libpurple.$(DYLIB_SUFFIX)\
	$(call EXPAND_DLLNAME,purplexpcom) purplexpcom.xpt \
	$(call EXPAND_DLLNAME,purpleloader) \
	$(NULL)

#see http://developer.mozilla.org/en/docs/XPCOM_Glue
$(call EXPAND_DLLNAME,purplexpcom): 	\
	src/purpleModule.o 		\
	src/purpleInit.o 		\
	src/purpleCoreService.o 	\
	src/purpleConversation.o 	\
	src/purpleProtocol.o		\
	src/purplePref.o		\
	src/purpleAccount.o		\
	src/purpleUtils.o		\
	src/purpleBuddy.o		\
	src/purpleTag.o			\
	src/purpleAccountBuddy.o	\
	src/purpleMessage.o		\
	src/purpleTimer.o		\
	src/purpleSockets.o		\
	src/purpleDNS.o			\
	src/purpleStorage.o		\
	libpurple.$(DYLIB_SUFFIX)	\
	../testapp/libraries/libglib-2.0.0.$(DYLIB_SUFFIX) \
	$(NULL)

	$(LINKXPCOM)
#	g++ -g -shared $^ -L$(GECKO_LIBS) -L$(GECKO_LIBS)/../bin -Wl,-rpath-link,$(GECKO_LIBS)/../bin,-rpath-link,../testapp/xulrunner -lxpcomglue_s -lxpcom -lnspr4 -o $@
#mac	g++ -g $^ -L$(GECKO_LIBS) -L$(GECKO_BINS) -Wl,-executable_path,$(MOZ_BINS) -lxpcomglue_s -lxpcom -lnspr4 -o $@ -Wl,-exported_symbols_list -Wl,/Users/florian/goinfre/instantbird/mozilla/build/unix/gnu-ld-scripts/components-export-list -bundle
#win	$(LD) -nologo -DLL -OUT:$@  $^ glib-2.0.lib -LIBPATH:$(GECKO_LIBS) xpcomglue_s.lib xpcom.lib nspr4.lib
#	$(LINK.dll) $^ $(LOADLIBES) $(LDLIBS) $(LD_OUT_OPTION)


purplexpcom.xpt:			\
	public/purpleICoreService.xpt	\
	public/purpleIConversation.xpt	\
	public/purpleIProtocol.xpt	\
	public/purpleIAccount.xpt	\
	public/purpleIPref.xpt		\
	public/purpleIBuddy.xpt		\
	public/purpleITag.xpt		\
	public/purpleIAccountBuddy.xpt	\
	public/purpleIMessage.xpt	\
	public/purpleISocket.xpt	\
	$(NULL)

	$(XPTLINK) $@ $^

$(call EXPAND_DLLNAME,purpleloader): \
	src/purpleLoader.o \
	$(NULL)

	$(LINKXPCOM)
#	g++ -g -shared $^ -L$(GECKO_LIBS) -L$(GECKO_LIBS)/../bin -Wl,-rpath-link,$(GECKO_LIBS)/../bin,-rpath-link,../testapp/xulrunner -lxpcomglue_s -lxpcom -lnspr4 -o $@
#mac	g++ -g $^ -L$(GECKO_LIBS) -L$(GECKO_BINS) -Wl,-executable_path,$(MOZ_BINS) -lxpcomglue_s -lxpcom -lnspr4 -o $@ -Wl,-exported_symbols_list -Wl,/Users/florian/goinfre/instantbird/mozilla/build/unix/gnu-ld-scripts/components-export-list -bundle
#win	$(LD) -nologo -DLL -OUT:$@  $^  -LIBPATH:$(GECKO_LIBS) xpcomglue_s.lib xpcom.lib nspr4.lib
#	$(LINK.dll) $^ $(LOADLIBES) $(LDLIBS) $(LD_OUT_OPTION)

install: all
	rm -rf dist
	mkdir -p dist/components dist/libraries
	cp purplexpcom.xpt $(call EXPAND_DLLNAME,purpleloader) dist/components
	cp $(call EXPAND_DLLNAME,purplexpcom) libpurple.$(DYLIB_SUFFIX) dist/libraries
	cp dist/libraries/* ../testapp/libraries
	cp dist/components/* ../testapp/components

# phony targets

clean:
	rm -f $(OBJS)

distclean: clean
	rm -f $(CONFIGJUNK)
	rm -rf dist

.PHONY: clean distclean

# configure and related build system fluff
configure: configure.in
	autoconf

config.status: configure
	./configure

config/config.mak: config.status config/config.mak.in
	./config.status

Makefile: config/config.mak

include config/depend.mak


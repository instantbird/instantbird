all:

-include config/config.mak
-include config/rules.mak

all: \
	libpurple.$(DYLIB_SUFFIX)\
	$(call EXPAND_DLLNAME,purplexpcom) purplexpcom.xpt \
	$(call EXPAND_DLLNAME,purpleloader) \
	$(NULL)

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
	src/purpleMessage.o		\
	$(NULL)

#see http://developer.mozilla.org/en/docs/XPCOM_Glue
	g++ -g -shared $^ libpurple.$(DYLIB_SUFFIX) -L$(GECKO_LIBS) -L$(GECKO_LIBS)/../bin -Wl,-rpath-link,$(GECKO_LIBS)/../bin,-rpath-link,../testapp/xulrunner -lxpcomglue_s -lxpcom -lnspr4 -o $@
#win	$(LD) -nologo -DLL -OUT:$@ -LIBPATH:$(GECKO_LIBS) xpcomglue_s.lib xpcom.lib nspr4.lib libpurple.lib $^
#	$(LINK.dll) $^ $(LOADLIBES) $(LDLIBS) $(LD_OUT_OPTION)


purplexpcom.xpt:			\
	public/purpleICoreService.xpt	\
	public/purpleIConversation.xpt	\
	public/purpleIProtocol.xpt	\
	public/purpleIAccount.xpt	\
	public/purpleIPref.xpt		\
	public/purpleIBuddy.xpt		\
	public/purpleIMessage.xpt	\
	$(NULL)

	$(XPTLINK) $@ $^

$(call EXPAND_DLLNAME,purpleloader): \
	src/purpleLoader.o \
#	$(GECKO_LIBS)/$(call EXPAND_LIBNAME,xpcomglue_s) \
#	$(GECKO_LIBS)/$(call EXPAND_DYLIBNAME,xpcom) \
#	$(GECKO_LIBS)/$(call EXPAND_DYLIBNAME,nspr4) \
	$(NULL)

	g++ -g -shared $^ -L$(GECKO_LIBS) -L$(GECKO_LIBS)/../bin -Wl,-rpath-link,$(GECKO_LIBS)/../bin,-rpath-link,../testapp/xulrunner -lxpcomglue_s -lxpcom -lnspr4 -o $@
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


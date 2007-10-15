DLL_PREFIX := lib
DLL_SUFFIX := so
DYLIB_PREFIX := lib
DYLIB_SUFFIX := so
LIB_PREFIX := lib
LIB_SUFFIX := a

libpurple.$(DYLIB_SUFFIX): libpurple.$(DYLIB_SUFFIX).0
	ln -s $< $@

libpurple.$(DYLIB_SUFFIX).0: $(LIBPURPLE_PATH)/libpurple.$(DYLIB_SUFFIX).0
	cp $< $@

OBJS += libpurple.$(DYLIB_SUFFIX).0

CXXFLAGS += -g -Wall -Wno-non-virtual-dtor -fshort-wchar

LINKXPCOM = g++ -g -shared $^ -L$(GECKO_LIBS) -L$(GECKO_BINS) -Wl,-rpath-link,$(GECKO_BINS),-rpath-link,../testapp/xulrunner -lxpcomglue_s -lxpcom -lnspr4 -o $@

DLL_PREFIX := lib
DLL_SUFFIX := dylib
DYLIB_PREFIX := lib
DYLIB_SUFFIX := dylib
LIB_PREFIX := lib
LIB_SUFFIX := a

libpurple.$(DYLIB_SUFFIX): libpurple.0.$(DYLIB_SUFFIX)
	ln -s $< $@

libpurple.0.$(DYLIB_SUFFIX): $(LIBPURPLE_PATH)/libpurple.0.$(DYLIB_SUFFIX)
	cp $< $@

OBJS += libpurple.0.$(DYLIB_SUFFIX)

CXXFLAGS += -g -Wall -Wno-non-virtual-dtor -DXP_MACOSX

LINKXPCOM = g++ -g $^ -L$(GECKO_LIBS) -L$(GECKO_BINS) -Wl,-executable_path,$(MOZ_BINS) -lxpcomglue_s -lxpcom -lnspr4 -o $@ -Wl,-exported_symbols_list -Wl,config/macosx/components-export-list -bundle

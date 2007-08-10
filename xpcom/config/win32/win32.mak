# this is win32 specific stuff

DLL_PREFIX := 
DLL_SUFFIX := dll
DYLIB_PREFIX := 
DYLIB_SUFFIX := lib
LIB_PREFIX := 
LIB_SUFFIX := lib


ifeq (,$(GNU_CC))

# msvc - we need to remake the lib because mingw's export libs don't work

# teach make to build the gaim import library
libgaim.$(DYLIB_SUFFIX): src/win32/libgaim.$(DYLIB_SUFFIX)
	mv $< $@

src/win32/libgaim.exports: $(GAIM_LIBS)/libgaim.$(DLL_SUFFIX)
	dumpbin -exports -out:$@ $^

# dlltool doesn't work because it lists things gaim _imports_ too
%.def: %.exports
	echo "LIBRARY" > $@
	echo "EXPORTS" >> $@
	# there has to be a better way...
	grep -E '[0-9]+.{6}[0-F]{8}' $< \
		| sed 's/ \+/ /g' \
		| cut '-d ' -f2,5 \
		| sed 's/\([0-9]\+\) \([A-Za-z0-9_]\+\)/ \2 @ \1/g' \
		>> $@

%.c: %.exports
	grep -E '[0-9]+.{6}[0-F]{8}' $< \
		| sed 's/ \+/ /g' \
		| cut '-d ' -f5 \
		| sed 's/\([A-Za-z0-9_]\+\)/ void \1 () {} /g' \
		> $@

%.ostub: %.c
	$(COMPILE.c) $(OUTPUT_OPTION) $<

%.lib: %.ostub %.def
	lib -def:$*.def -out:$@ $<

OBJS += \
    $(call EXPAND_DYLIBNAME,gaimloader) gaimloader.exp \
    $(call EXPAND_DYLIBNAME,gaimxpcom) gaimxpcom.exp \
    src/win32/libgaim.exp src/win32/libgaim.exports \
    $(NULL)


else
# mingw
DYLIB_PREFIX := lib
DYLIB_SUFFIX := dll.a
LIB_PREFIX := lib
LIB_SUFFIX := a

CPPFLAGS += -fshort-wchar

libgaim.$(DYLIB_SUFFIX): $(GAIM_LIBS)/libgaim.$(DYLIB_SUFFIX)
	cp $< $@
endif
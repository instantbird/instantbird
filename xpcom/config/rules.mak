# xpidl related
%.h: ../public/%.idl
	$(XPIDL) -m header -I $(XPIDLINCLUDES) -I public/ -e $@ $^
public/%.xpt: public/%.idl
	$(XPIDL) -m typelib -w -I $(XPIDLINCLUDES) -I public/ -e $@ $^

# preprocess files
%.i: %.c
	$(CPP) $(CPPFLAGS) $< > $@
%.i: %.cpp
	$(CXXCPP) $(CPPFLAGS) $< > $@

# linking related
# the prefix/suffixes are set in platform-specific makefiles
EXPAND_LIBNAME = $(LIB_PREFIX)$(1).$(LIB_SUFFIX)
EXPAND_DLLNAME = $(DLL_PREFIX)$(1).$(DLL_SUFFIX)
EXPAND_DYLIBNAME = $(DYLIB_PREFIX)$(1).$(DYLIB_SUFFIX)

ifeq (_,$(filter-out WINNT,$(OS_TARGET))_$(GNU_CC))
    LINK.dll = $(LD) -nologo -DLL -OUT:$@ $(LDFLAGS) $(TARGET_ARCH)
else
    LINK.dll = $(LD) -shared -o $@ $(LDFLAGS) $(TARGET_ARCH)
endif

CXXFLAGS += -DDLL_PREFIX=\"$(DLL_PREFIX)\" -DDLL_SUFFIX=\".$(DLL_SUFFIX)\"

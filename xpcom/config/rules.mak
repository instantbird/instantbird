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

CXXFLAGS += -DDLL_PREFIX=\"$(DLL_PREFIX)\" -DDLL_SUFFIX=\".$(DLL_SUFFIX)\"

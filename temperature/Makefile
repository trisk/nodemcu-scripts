CAT = /bin/cat
SED = /bin/sed
COMMON_DIR = ../common
INIT_FILES = wifi.lua $(COMMON_DIR)/server.lua thermo.lua

init.lua: $(INIT_FILES)
	$(CAT) $(INIT_FILES) | sed '/^ *$$/d' > $@

all: init.lua
-include $(COMMON_DIR)/wifi.mk

wifi.lua: $(COMMON_DIR)/wifi.lua.in
	$(CAT) $^ | $(SED) -e '/^ *$$/d' \
		-e 's,__WIFI_ESSID__,$(WIFI_ESSID),g' \
		-e 's,__WIFI_PASS__,$(WIFI_PASS),g' \
		> $@

-include $(COMMON_DIR)/private.mk

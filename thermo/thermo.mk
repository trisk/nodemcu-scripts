thermo.lua: thermo.lua.in
	$(CAT) $^ | $(SED) -e '/^ *$$/d' \
		-e 's,__RTCOA_HOST__,$(RTCOA_HOST),g' \
		-e 's,__TS_API_KEY__,$(TS_API_KEY),g' \
		> $@

-include private.mk

Common scripts
==============

## wifi.lua
Basic WiFi connectivity, used as prologue to `init.lua`. Include `wifi.mk` in
your Makefile and create `private.mk` to generate `wifi.lua`.

## telnet.lua
Basic telnet server, similar to the NodeMCU example.

## server.lua
Combined lightweight Web server and telnet server,  so I can still upload
files remotely. Populate the `handlers` table with a function for each path.

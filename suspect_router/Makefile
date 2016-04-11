all: admpanel
admpanel: admpanel.nim
	nim c -d:release --opt:size --cpu:mips --os:linux $<
	mips-openwrt-linux-strip $@
clean:
	rm -f admpanel
	rm -rf nimcache

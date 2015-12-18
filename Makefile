build_dir := build

.PHONY: all
all:
	@echo "Make what specifically?"
	@echo "The most common target is 'iso'"

.PHONY: prepare
prepare:
	@echo "Starting VyOS ISO image build"

	@scripts/check-build-env
	@scripts/check-config

	@scripts/live-build-config
	cp -r data/includes.chroot/* build/config/includes.chroot/
	cp -r data/package-lists/common/* build/config/package-lists/

.PHONY: iso
.ONESHELL:
iso: prepare
	@echo "It's not like I'm building this specially for you or anything!"
	cd $(build_dir)
	lb build 2>&1 | tee build.log
	@echo "VyOS ISO build successful"

.PHONY: clean
.ONESHELL:
clean:
	cd $(build_dir)
	lb clean

	rm -f config/binary config/bootstrap config/chroot config/common config/source
	rm -f build.log

.PHONY: purge
purge:
	rm -rf build/*

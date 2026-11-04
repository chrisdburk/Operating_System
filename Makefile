# Convenience shortcuts. Run `make help` for the list.
.PHONY: help iso docker-iso config clean lint

help:
	@echo "make iso         Build the ISO on a Debian host (needs root + live-build)"
	@echo "make docker-iso  Build the ISO inside Docker (any Linux host)"
	@echo "make config      Only prepare build/ so you can inspect the result"
	@echo "make clean       Remove build/"
	@echo "make lint        Run shellcheck on all scripts"

iso:
	sudo ./build.sh build

docker-iso:
	./build-in-docker.sh build

config:
	sudo ./build.sh config

clean:
	sudo ./build.sh clean

lint:
	shellcheck -x build.sh build-in-docker.sh config/hooks/normal/*.hook.chroot config/includes.chroot/usr/local/bin/*

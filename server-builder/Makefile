.PHONY: build release latest unstable

include ../Makefile.inc

IMAGE ?= cortezaproject/corteza-server-builder
TAG    = 1.15

build:
	$(DOCKER) build $(DOCKER_BUILD_OPTS) --tag $(IMAGE):$(TAG) .

release:
	$(DOCKER) push $(IMAGE):$(TAG)

latest:
	$(DOCKER) tag $(IMAGE):$(TAG) $(IMAGE):latest
	$(DOCKER) push $(IMAGE):latest

.PHONY: build push

DOCKER = docker

# Flags
DOCKER_BUILD_FLAGS ?= --no-cache --rm # example: make build.server DOCKER_BUILD_FLAGS=--rm
DOCKER_BUILD_ARGS  ?=

IMAGE ?= cortezaproject/corteza-server-builder
TAG   ?= 1.15

build:
	$(DOCKER) build \
		$(DOCKER_BUILD_FLAGS) \
		$(DOCKER_BUILD_ARGS) \
		--tag $(IMAGE):$(TAG) \
		.

push:
	$(DOCKER) push $(IMAGE):$(TAG)

latest:
	$(DOCKER) tag $(IMAGE):$(TAG) $(IMAGE):latest
	$(DOCKER) push $(IMAGE):latest

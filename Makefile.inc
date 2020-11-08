# Binaries
DOCKER = docker

# Other, centralised settings
FLAVOUR ?= corteza

ifeq ($(VERSION),)
$(error VERSION is not set. Make sure you specify it, eg: make build VERSION=2020.12.0)
endif

vFULL  := $(VERSION)
vVALID := $(shell [[ $(vFULL) =~ 202[0-9].(3|6|9|12)(.[0-9]+)?$$ ]] && echo "yes")
vPATCH := $(shell [[ $(vFULL) =~ 202[0-9].(3|6|9|12).([0-9]+)$$ ]] && echo "yes")

ifneq ($(vVALID),)
ifeq ($(vPATCH),)
	vFULL := $(addsuffix .0,$(vFULL))
endif
endif

# The actual shorten version:
vSHORT := $(word 1,$(subst ., ,$(vFULL))).$(word 2,$(subst ., ,$(vFULL)))

ifeq ($(FLAVOUR),crust)
	IMAGE_PFIX = crusttech/crust-
else
	IMAGE_PFIX = cortezaproject/corteza-
endif

# Docker build flags, build arguments and combined options
DOCKER_BUILD_FLAGS ?= --no-cache --rm # example: make build.server DOCKER_BUILD_FLAGS=--rm
DOCKER_BUILD_ARGS  ?= --build-arg C_VERSION=$(vFULL) --build-arg C_FLAVOUR=$(FLAVOUR)
DOCKER_BUILD_OPTS  ?= $(DOCKER_BUILD_FLAGS) $(DOCKER_BUILD_ARGS)

all: | build push

# Generic docker build
build:
	$(DOCKER) build $(DOCKER_BUILD_OPTS) --tag $(IMAGE):$(vFULL) .
ifneq ($(vVALID),)
	docker tag $(IMAGE):$(vFULL) $(IMAGE):$(vSHORT)
ifneq ($(LATEST),)
	docker tag $(IMAGE):$(vFULL) $(IMAGE):latest
endif
endif

# Generic docker push
push:
	$(DOCKER) push $(IMAGE):$(vFULL)
ifneq ($(vVALID),)
	docker push $(IMAGE):$(vSHORT)
ifneq ($(LATEST),)
	docker push $(IMAGE):latest
endif
endif

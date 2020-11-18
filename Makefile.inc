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

VERSION                  ?= $(vFULL)
VERSION_WEBAPP           ?= $(VERSION)
VERSION_WEBAPP_ONE       ?= $(VERSION_WEBAPP)
VERSION_WEBAPP_ADMIN     ?= $(VERSION_WEBAPP)
VERSION_WEBAPP_AUTH      ?= $(VERSION_WEBAPP)
VERSION_WEBAPP_COMPOSE   ?= $(VERSION_WEBAPP)
VERSION_WEBAPP_MESSAGING ?= $(VERSION_WEBAPP)

# Docker build flags, build arguments and combined options
DOCKER_BUILD_FLAGS ?= --no-cache --rm # example: make build.server DOCKER_BUILD_FLAGS=--rm
DOCKER_BUILD_FLAGS += --build-arg C_FLAVOUR=$(FLAVOUR)
DOCKER_BUILD_FLAGS += --build-arg C_VERSION=$(VERSION)
DOCKER_BUILD_FLAGS += --build-arg C_VERSION_WEBAPP=$(VERSION_WEBAPP)
DOCKER_BUILD_FLAGS += --build-arg C_VERSION_WEBAPP_ONE=$(VERSION_WEBAPP_ONE)
DOCKER_BUILD_FLAGS += --build-arg C_VERSION_WEBAPP_ADMIN=$(VERSION_WEBAPP_ADMIN)
DOCKER_BUILD_FLAGS += --build-arg C_VERSION_WEBAPP_AUTH=$(VERSION_WEBAPP_AUTH)
DOCKER_BUILD_FLAGS += --build-arg C_VERSION_WEBAPP_COMPOSE=$(VERSION_WEBAPP_COMPOSE)
DOCKER_BUILD_FLAGS += --build-arg C_VERSION_WEBAPP_MESSAGING=$(VERSION_WEBAPP_MESSAGING)

all: | build push

# Generic docker build
build:
	$(DOCKER) build $(DOCKER_BUILD_FLAGS) --tag $(IMAGE):$(vFULL) .
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

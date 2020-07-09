.PHONY: build push run

# All known outputs (output = directory on root)
OUTPUTS = server-system server-compose server-messaging server-monolith aio demo webapp corredor server-builder webapp-builder

# Binaries
DOCKER = docker
GIT    = git

# Other, centralised settings
FLAVOUR     ?= corteza
VERSION     ?= $(shell $(GIT) describe --tags --abbrev=0)
TAG         ?= $(VERSION)
RETAG       ?= $(TAG)

ifeq ($(FLAVOUR),crust)
	IMAGE_PFIX=crusttech/crust-
else
	IMAGE_PFIX=cortezaproject/corteza-
endif

BUILD_LIST  ?= $(addprefix build., $(OUTPUTS))
PUSH_LIST   ?= $(addprefix push., $(OUTPUTS))

# Flags
DOCKER_BUILD_FLAGS ?= --no-cache --rm # example: make build.server DOCKER_BUILD_FLAGS=--rm
DOCKER_BUILD_ARGS  ?= --build-arg C_VERSION=$(VERSION) --build-arg C_FLAVOUR=$(FLAVOUR)

# Calls build+output for each OUTPUTS
build: $(BUILD_LIST)

build.corredor: build.server-corredor

# Build one of the output, uses <output>/Dockerfile
build.%: %/Dockerfile
	$(DOCKER) build \
		$(DOCKER_BUILD_FLAGS) \
		$(DOCKER_BUILD_ARGS) \
		--tag $(IMAGE_PFIX)$*:$(TAG) \
		$*/.

build.server-corredor:
	$(DOCKER) build \
	$(DOCKER_BUILD_FLAGS) \
	$(DOCKER_BUILD_ARGS) \
	--tag $(IMAGE_PFIX)server-corredor:$(TAG) \
	corredor/.

# Special make task for server image building
# We're using same Dockerfile for all server apps,
# passing different build arg and tagging with a different tag
build.server-%:
	$(DOCKER) build \
		$(DOCKER_BUILD_FLAGS) \
		--build-arg C_APP=$* \
		$(DOCKER_BUILD_ARGS) \
		--tag $(IMAGE_PFIX)server-$*:$(TAG) \
		server/.

# Calls push+output for each OUTPUTS
push: $(PUSH_LIST)

push.%: %/Dockerfile
	$(DOCKER) push $(IMAGE_PFIX)$*:$(TAG)

push.server-%:
	$(DOCKER) push $(IMAGE_PFIX)server-$*:$(TAG)

# Shorthand to build & push unstable versions of monolith, corredor & webapp
release.unstable:
	$(MAKE) build.server-monolith push.server-monolith VERSION=unstable
	$(MAKE) build.server-corredor push.server-corredor VERSION=unstable
	$(MAKE) build.webapp push.webapp VERSION=unstable

tag.%:
	docker tag $(IMAGE_PFIX)$*:$(TAG) $(IMAGE_PFIX)$*:$(RETAG)

# Shorthand to build & push 2020.6.x
release.20%:
	$(MAKE) -j3 build.server-monolith build.server-corredor build.webapp build.aio VERSION=20$*
	$(MAKE) tag.server-monolith tag.server-corredor tag.webapp tag.aio TAG=20$* RETAG=20$(word 1,$(subst ., ,$*)).$(word 2,$(subst ., ,$*))
	$(MAKE) tag.server-monolith tag.server-corredor tag.webapp tag.aio TAG=20$* RETAG=latest

	$(MAKE) -j3 push.server-monolith push.server-corredor push.webapp push.aio VERSION=20$*
	$(MAKE) -j3 push.server-monolith push.server-corredor push.webapp push.aio VERSION=20$(word 1,$(subst ., ,$*)).$(word 2,$(subst ., ,$*))
	$(MAKE) -j3 push.server-monolith push.server-corredor push.webapp push.aio VERSION=latest

# Shorthand to build & push unstable crust
release-crust.unstable:
	$(MAKE) -j3 build.server-monolith build.server-corredor build.webapp FLAVOUR=crust VERSION=unstable

# Shorthand to build & push 2020.6.x
release-crust.20%:
	$(MAKE) -j3 build.server-monolith build.server-corredor build.webapp FLAVOUR=crust VERSION=20$*
	$(MAKE) tag.server-monolith tag.server-corredor tag.webapp tag.aio FLAVOUR=crust TAG=20$* RETAG=20$(word 1,$(subst ., ,$*)).$(word 2,$(subst ., ,$*))
	$(MAKE) tag.server-monolith tag.server-corredor tag.webapp tag.aio FLAVOUR=crust TAG=20$* RETAG=latest

	$(MAKE) -j3 push.server-monolith push.server-corredor push.webapp push.aio FLAVOUR=crust VERSION=20$*
	$(MAKE) -j3 push.server-monolith push.server-corredor push.webapp push.aio FLAVOUR=crust VERSION=20$(word 1,$(subst ., ,$*)).$(word 2,$(subst ., ,$*))
	$(MAKE) -j3 push.server-monolith push.server-corredor push.webapp push.aio FLAVOUR=crust VERSION=latest

.PHONY: build push run

# All known outputs (output = directory on root)
OUTPUTS = server-system server-compose server-messaging server-monolith aio demo webapp corredor

# Binaries
DOCKER = docker
GIT    = git

# Flags
DOCKER_BUILD_FLAGS ?= --no-cache --rm # example: make build.server DOCKER_BUILD_FLAGS=--rm
DOCKER_BUILD_ARGS  ?= --build-arg C_VERSION=$(VERSION)

# Other, centralised settings
IMAGE_PFIX   = cortezaproject/corteza-
VERSION     ?= $(shell $(GIT) describe --tags --abbrev=0)

BUILD_LIST  ?= $(addprefix build., $(OUTPUTS))
PUSH_LIST   ?= $(addprefix push., $(OUTPUTS))

# Calls build+output for each OUTPUTS
build: $(BUILD_LIST)

build.corredor: build.server-corredor

# Build one of the output, uses <output>/Dockerfile
build.%: %/Dockerfile
	$(DOCKER) build \
		$(DOCKER_BUILD_FLAGS) \
		$(DOCKER_BUILD_ARGS) \
		--tag $(IMAGE_PFIX)$*:$(VERSION) \
		$*/.

build.server-corredor:
	$(DOCKER) build \
	$(DOCKER_BUILD_FLAGS) \
	$(DOCKER_BUILD_ARGS) \
	--tag $(IMAGE_PFIX)server-corredor:$(VERSION) \
	corredor/.

# Special make task for server image building
# We're using same Dockerfile for all server apps,
# passing different build arg and tagging with a different tag
build.server-%:
	$(DOCKER) build \
		$(DOCKER_BUILD_FLAGS) \
		--build-arg C_APP=$* \
		$(DOCKER_BUILD_ARGS) \
		--tag $(IMAGE_PFIX)server-$*:$(VERSION) \
		server/.

# Calls push+output for each OUTPUTS
push: $(PUSHALL)

push.%: %/Dockerfile
	$(DOCKER) push $(IMAGE_PFIX)$*:$(VERSION)

push.server-%:
	$(DOCKER) push $(IMAGE_PFIX)server-$*:$(VERSION)

release.unstable:
	$(MAKE) build.server-monolith push.server-monolith VERSION=unstable
	$(MAKE) build.server-corredor push.server-corredor VERSION=unstable
	$(MAKE) build.webapp push.webapp VERSION=unstable

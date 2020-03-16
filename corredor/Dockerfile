FROM node:12.14-alpine AS build

# Cairo&co are needed for PDF rendering
ARG C_FLAVOUR="corteza"
ARG C_VERSION="2020.3.0"
ARG C_REMOTE_BASE_URL="https://releases.cortezaproject.org/files"
ARG C_PKG_NAME="${C_FLAVOUR}-server-corredor-${C_VERSION}.tar.gz"
ARG C_HOME_DIR="/${C_FLAVOUR}"
ARG C_USER="${C_FLAVOUR}"
ARG C_GROUP="${C_FLAVOUR}"
ARG C_UID="4242"
ARG C_GID="4242"
ARG C_GRPC_PORT="80"
ARG C_EXT_DIR="corteza-ext"
ARG C_EXT_BRANCH="develop"
ARG C_EXT_URL="https://github.com/cortezaproject/${C_EXT_DIR}/archive/${C_EXT_BRANCH}.tar.gz"
ARG C_EXT_DST="/extensions"
ARG C_EXT_BRANCH="develop"

# Create app directory
WORKDIR ${C_HOME_DIR}

ADD *.tar.gz build.d/* /build.d/

RUN chmod +x /build.d/* \
 && run-parts --exit-on-error /build.d \
 && rm -rf /build.d


## Copy the app (so that yarn install can be cached)
#COPY ../../corteza-server-corredor/src /corredor/src/
#
## Get ready
#RUN mkdir -p /corredor/usr /corredor/corteza-ext /corredor/usr \
# && ls /corredor/scripts \
# && BRANCH=develop sh /corredor/scripts/extensions.sh \
# && yarn build

# GRPC's env-vars
# https://github.com/grpc/grpc/blob/master/doc/environment_variables.md
ENV GRPC_VERBOSITY=ERROR

# Set Corredor's default ENV values
ENV CORREDOR_ENVIRONMENT=prod
ENV CORREDOR_LOG_PRETTY=false
ENV CORREDOR_LOG_LEVEL=info
ENV CORREDOR_LOG_ENABLED=true

ENV CORREDOR_ADDR=0.0.0.0:${C_GRPC_PORT}

ENV CORREDOR_SERVER_CERTIFICATES_ENABLED=false

ENV CORREDOR_SCRIPTS_AUTO_UPDATE_DEPENDENCIES=false
ENV CORREDOR_EXT_SERVER_SCRIPTS_WATCH=false
ENV CORREDOR_EXT_CLIENT_SCRIPTS_WATCH=false

ENV CORREDOR_EXT_SEARCH_PATHS=/corredor/extensions/*:/corredor/usr/*:/corredor/usr

# Client & server scripts location for user scripts & extensions
VOLUME /corredor/usr

# TLS certificates should be placed here if CORREDOR_SERVER_CERTIFICATES_ENABLED
VOLUME /corredor/certs

EXPOSE $C_GRPC_PORT
ENTRYPOINT ["/usr/local/bin/node"]
CMD ["dist/server.js"]

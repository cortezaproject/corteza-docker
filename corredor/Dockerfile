FROM node:12.14-alpine AS build

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

COPY *.tar.gz build.d /build.d/
RUN chmod +x /build.d/??_* \
 && run-parts --exit-on-error /build.d \
 && rm -rf /build.d


# GRPC's env-vars
# https://github.com/grpc/grpc/blob/master/doc/environment_variables.md
ENV GRPC_VERBOSITY=ERROR

# Set Corredor's default ENV values
ENV CORREDOR_ENVIRONMENT=prod
ENV CORREDOR_LOG_PRETTY=false
ENV CORREDOR_LOG_LEVEL=info
ENV CORREDOR_LOG_ENABLED=true

ENV C_GRPC_PORT=${C_GRPC_PORT}
ENV CORREDOR_ADDR=0.0.0.0:${C_GRPC_PORT}

ENV CORREDOR_SERVER_CERTIFICATES_ENABLED=false

ENV CORREDOR_SCRIPTS_AUTO_UPDATE_DEPENDENCIES=false
ENV CORREDOR_EXT_SERVER_SCRIPTS_WATCH=false
ENV CORREDOR_EXT_CLIENT_SCRIPTS_WATCH=false

ENV CORREDOR_EXT_SEARCH_PATHS=${C_EXT_DST}/*:/corredor/usr/*:/corredor/usr

# Client & server scripts location for user scripts & extensions
VOLUME /corredor/usr

# TLS certificates should be placed here if CORREDOR_SERVER_CERTIFICATES_ENABLED
VOLUME /corredor/certs

HEALTHCHECK --interval=3m --timeout=3s --start-period=60s \
    CMD curl --fail "http://127.0.0.1:${C_HTTP_PORT}" || exit 1

EXPOSE ${C_GRPC_PORT}

ENTRYPOINT ["/usr/local/bin/node"]
CMD ["dist/server.js"]

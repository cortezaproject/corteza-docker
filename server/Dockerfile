FROM alpine:3.11

ARG C_OS="linux"
ARG C_ARCH="amd64"
ARG C_FLAVOUR="corteza"
ARG C_VERSION="2020.12.0"
ARG C_VERSION_WEBAPP="${C_VERSION}"
ARG C_VERSION_WEBAPP_ONE="${C_VERSION_WEBAPP}"
ARG C_VERSION_WEBAPP_ADMIN="${C_VERSION_WEBAPP}"
ARG C_VERSION_WEBAPP_AUTH="${C_VERSION_WEBAPP}"
ARG C_VERSION_WEBAPP_COMPOSE="${C_VERSION_WEBAPP}"
ARG C_VERSION_WEBAPP_MESSAGING="${C_VERSION_WEBAPP}"
ARG C_REMOTE_BASE_URL="https://releases.cortezaproject.org/files"
ARG C_HOME_DIR="/${C_FLAVOUR}"
ARG C_BASE_DIR="${C_HOME_DIR}/webapp"
ARG C_USER="${C_FLAVOUR}"
ARG C_GROUP="${C_FLAVOUR}"
ARG C_UID="4242"
ARG C_GID="4242"
ARG C_HTTP_PORT="80"

# Making a couple of assumptions about environment

# Data will most likely be mounted on /data
ENV STORAGE_PATH           /data

# Corredor server will run under "corredor" docker container service
ENV CORREDOR_ADDR          corredor:80

# Where can server binaries can be found
ENV PATH                   "${C_HOME_DIR}/bin:${PATH}"

# Where Corteza API is running?
ENV C_HTTP_PORT            $C_HTTP_PORT
ENV HTTP_ADDR              0.0.0.0:${C_HTTP_PORT}



COPY *.tar.gz build.d /build.d/
COPY src/healthcheck.sh /bin/healthcheck
RUN chmod +x /bin/healthcheck \
 && chmod +x /build.d/??_* \
 && run-parts --exit-on-error /build.d \
 && rm -rf /build.d

USER $C_USER

VOLUME /data

WORKDIR ${C_HOME_DIR}

HEALTHCHECK --interval=30s --start-period=1m --timeout=30s --retries=3 CMD sh /bin/healthcheck

EXPOSE ${C_HTTP_PORT}

ENTRYPOINT [ "bin/server" ]
CMD ["serve-api"]

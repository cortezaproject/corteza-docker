FROM alpine:3.11

ARG C_OS="linux"
ARG C_ARCH="amd64"
ARG C_FLAVOUR="corteza"
ARG C_APP="monolith"
ARG C_VERSION="2020.3.0"
ARG C_REMOTE_BASE_URL="https://releases.cortezaproject.org/files"
ARG C_PKG_NAME="${C_FLAVOUR}-server-${C_APP}-${C_VERSION}-${C_OS}-${C_ARCH}.tar.gz"
ARG C_HOME_DIR="/${C_FLAVOUR}"
ARG C_USER="${C_FLAVOUR}"
ARG C_GROUP="${C_FLAVOUR}"
ARG C_UID="4242"
ARG C_GID="4242"
ARG C_HTTP_PORT="80"

ENV COMPOSE_STORAGE_PATH   ${C_HOME_DIR}/data/compose
ENV MESSAGING_STORAGE_PATH ${C_HOME_DIR}/data/messaging
ENV SYSTEM_STORAGE_PATH    ${C_HOME_DIR}/data/system
ENV CORREDOR_ADDR          corredor:${C_HTTP_PORT}
ENV PATH                   "${C_HOME_DIR}/bin:${PATH}"
ENV C_HTTP_PORT            $C_HTTP_PORT

COPY *.tar.gz build.d /build.d/
RUN chmod +x /build.d/??_* \
 && run-parts --exit-on-error /build.d \
 && rm -rf /build.d


USER $C_USER

VOLUME ${C_HOME_DIR}/data

WORKDIR ${C_HOME_DIR}

HEALTHCHECK --interval=3m --timeout=3s --start-period=60s \
    CMD curl --fail "http://127.0.0.1:${C_HTTP_PORT}" || exit 1

EXPOSE ${C_HTTP_PORT}

ENTRYPOINT [ "/corteza/bin/server" ]
CMD ["serve-api"]

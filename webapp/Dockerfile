FROM alpine:3.11 AS builder

ARG C_FLAVOUR="corteza"
ARG C_VERSION="2020.12.0"
ARG C_VERSION_WEBAPP_ONE="${C_VERSION}"
ARG C_VERSION_WEBAPP_ADMIN="${C_VERSION}"
ARG C_VERSION_WEBAPP_AUTH="${C_VERSION}"
ARG C_VERSION_WEBAPP_COMPOSE="${C_VERSION}"
ARG C_VERSION_WEBAPP_MESSAGING="${C_VERSION}"
ARG C_REMOTE_BASE_URL="https://releases.cortezaproject.org/files"
ARG C_BASE_DIR="/webapp"
ARG C_HTTP_PORT="80"
ARG C_PKG_EXT="tar.gz"

COPY *.tar.gz build.d /build.d/
RUN chmod +x /build.d/??_* \
 && run-parts --exit-on-error /build.d \
 && rm -rf /build.d

FROM nginx:1.17-alpine

ARG C_BASE_DIR="/webapp"
ARG C_HTTP_PORT="80"
ENV C_HTTP_PORT $C_HTTP_PORT

RUN nginx -t

COPY --from=builder "/webapp" "/webapp"
COPY src/entrypoint.sh src/autoconfig.sh /
COPY src/nginx.conf /etc/nginx/nginx.conf

RUN chmod +x /*.sh

# A simple check, should not waste time on waiting, timeouts...

HEALTHCHECK --interval=30s --start-period=10s --timeout=30s  \
    CMD wget --quiet --tries=1 --spider "http://127.0.0.1:${C_HTTP_PORT}/config.js" || exit 1

EXPOSE ${C_HTTP_PORT}

WORKDIR "/${C_BASE_DIR}"

ENTRYPOINT ["/entrypoint.sh"]

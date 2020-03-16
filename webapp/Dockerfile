FROM alpine:3.11 AS builder

RUN apk add --no-cache \
      curl \
 && rm -rf /tmp/*


ARG C_APP="dummy"
ARG C_FLAVOUR="corteza"
ARG C_VERSION="2020.3.0"
ARG C_VERSION_ONE="${C_VERSION}"
ARG C_VERSION_ADMIN="${C_VERSION}"
ARG C_VERSION_AUTH="${C_VERSION}"
ARG C_VERSION_COMPOSE="${C_VERSION}"
ARG C_VERSION_MESSAGING="${C_VERSION}"
ARG C_REMOTE_BASE_URL="https://releases.cortezaproject.org/files"
ARG C_BASE_DIR="/webapp"
ARG C_HTTP_PORT="80"
ARG C_PKG_EXT="tar.gz"

COPY build.sh "${C_FLAVOUR}-webapp-*.${C_PKG_EXT}" /

RUN sh /build.sh

FROM nginx:1.17-alpine

ARG C_BASE_DIR="/webapp"
ARG C_HTTP_PORT="80"
ENV C_HTTP_PORT $C_HTTP_PORT

RUN nginx -t

COPY --from=builder "/webapp" "/webapp"
COPY entrypoint.sh autoconfig.sh /
COPY nginx.conf /etc/nginx/nginx.conf

RUN chmod +x /*.sh

# A simple check, should not waste time on waiting, timeouts...
HEALTHCHECK --interval=5m --timeout=1s --start-period=3s \
    CMD wget --quiet --tries=1 --spider "http://127.0.0.1:${C_HTTP_PORT}/config.js" || exit 1

EXPOSE ${C_HTTP_PORT}

WORKDIR "/${C_BASE_DIR}"

ENTRYPOINT ["/entrypoint.sh"]

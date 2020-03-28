FROM node:12.14-alpine

ARG C_FLAVOUR="corteza"
ARG C_VERSION="2020.3.0"
ARG C_UID="4242"
ARG C_GID="4242"
ARG C_HTTP_PORT="80"
ARG C_HOME_DIR="/${C_FLAVOUR}"
ARG C_USER="${C_FLAVOUR}"
ARG C_GROUP="${C_FLAVOUR}"

# Create app directory
WORKDIR ${C_HOME_DIR}

ENV STORAGE_PATH           /data
ENV CORREDOR_ADDR          corredor:${C_HTTP_PORT}
ENV PATH                   "${C_HOME_DIR}/bin:${PATH}"
ENV C_HTTP_PORT            $C_HTTP_PORT
ENV HTTP_ADDR              0.0.0.0:${C_HTTP_PORT}
ENV HTTP_API_BASE_URL      "/api"
ENV HTTP_WEBAPP_BASE_DIR   "webapp"
ENV HTTP_WEBAPP_ENABLED    true

COPY --from=cortezaproject/corteza-server-corredor:unstable "/corredor" "/corredor"
COPY --from=cortezaproject/corteza-server-corredor:unstable "/extensions" "/extensions"
COPY --from=cortezaproject/corteza-server-monolith:unstable "/corteza"  "/corteza"
COPY --from=cortezaproject/corteza-webapp:unstable          "/webapp"   "/webapp"

COPY build.d /build.d/
COPY src/entrypoint.sh /
COPY src/supervisor.conf /etc/supervisord.conf
RUN chmod +x /build.d/??_* \
 && run-parts --exit-on-error /build.d \
 && rm -rf /build.d

USER $C_USER

EXPOSE ${C_HTTP_PORT}

ENTRYPOINT [ "/entrypoint.sh" ]

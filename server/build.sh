#!/bin/sh

set -eu
#set -eux # debugging

TAR_FLAGS=-xzmok

HOME_TMP="${C_HOME_DIR}/tmp"

install_bin() {
  LOCAL_PATH="/${C_PKG_NAME}"
  REMOTE_URL="${C_REMOTE_BASE_URL}/${C_PKG_NAME}"

  # See if COPY in Dockerfile picked up any local dist files
  # and use them instead of downloading the whole package
  #
  # Used mainly for debugging
  if [ -f "${LOCAL_PATH}" ]; then
    ls -lsa ${LOCAL_PATH}
    tar ${TAR_FLAGS} -f "${LOCAL_PATH}" -C "${HOME_TMP}";
  else
    curl -qq --head --fail "${REMOTE_URL}"
    curl -qq "${REMOTE_URL}" | tar ${TAR_FLAGS} -C "${HOME_TMP}"
  fi

  mv "${HOME_TMP}/${C_FLAVOUR}-server-${C_APP}/"* "${C_HOME_DIR}/"
  rm -rf "${HOME_TMP}"

  # Released packages have "<flavour>-server-<app>" named binaries
  #
  # we'll ink them to simple "server" that can be used as entrypoint
  ln -s "${C_HOME_DIR}/bin/${C_FLAVOUR}-server-${C_APP}" "${C_HOME_DIR}/bin/server"
}


addgroup -g "${C_GID}" "${C_GROUP}"
adduser -D -u "${C_UID}" -G "${C_GROUP}" -h "${C_HOME_DIR}" "${C_USER}"

mkdir -p \
  "${COMPOSE_STORAGE_PATH}" \
  "${MESSAGING_STORAGE_PATH}" \
  "${SYSTEM_STORAGE_PATH}" \
  "${HOME_TMP}"

install_bin "${C_APP}"

chmod -R u+Xr-w,g+Xr-w "${C_HOME_DIR}"
chown -R "${C_USER}":"${C_GROUP}" "${C_HOME_DIR}"

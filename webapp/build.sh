#!/usr/bin/env sh

set -eu

TAR_FLAGS=-xzmok

install_pkg() {
  APP=${1}
  VER=${2}
  DST=${3}
  PKG="${C_FLAVOUR}-webapp-${APP}-${C_VERSION}.${C_PKG_EXT}"
  URL="${C_REMOTE_BASE_URL}/${PKG}"
  TMP="${C_BASE_DIR}/${PKG}"

	mkdir -p "${C_BASE_DIR}/${DST}"

  if [ -f "${TMP}" ]; then
    tar ${TAR_FLAGS} -f "${TMP}" -C "${C_BASE_DIR}/${DST}"
  else
    curl -s --head --fail "${URL}"
    curl -s "${URL?}" | tar ${TAR_FLAGS} -C "${C_BASE_DIR}/${DST}"
  fi
}


install_pkg "one"       "${C_VERSION_ONE}"       ""
install_pkg "admin"     "${C_VERSION_ADMIN}"     "admin"
install_pkg "auth"      "${C_VERSION_AUTH}"      "auth"
install_pkg "compose"   "${C_VERSION_COMPOSE}"   "compose"
install_pkg "messaging" "${C_VERSION_MESSAGING}" "messaging"

#!/bin/sh

set -eu

################################################################################
# (re)generate configuration files

# Where to put the configs
BASEDIR=${BASEDIR:-"/webapp"}

FEDERATION_ENABLED=${FEDERATION_ENABLED:-""}


# See if VIRTUAL_HOST exists
# if it does, it should hold the hostname of where these webapps are served
VIRTUAL_HOST=${VIRTUAL_HOST:-"local.cortezaproject.org"}

# Assume API is using same scheme as webapps
API_SCHEME=${API_SCHEME:-""}

# Prefix to use with VIRTUAL_HOST when building API domain
API_PREFIX=${API_PREFIX:-"api."}

API_BASEURL=${API_BASEURL:-"${API_PREFIX}${VIRTUAL_HOST}"}
API_BASEURL_SYSTEM=${API_BASEURL_SYSTEM:-"${API_SCHEME}//${API_BASEURL}/system"}
API_BASEURL_COMPOSE=${API_BASEURL_COMPOSE:-"${API_SCHEME}//${API_BASEURL}/compose"}
API_BASEURL_FEDERATION=${API_BASEURL_FEDERATION:-"${API_SCHEME}//${API_BASEURL}/federation"}

CONFIG=""
CONFIG="${CONFIG}window.SystemAPI = '${API_BASEURL_SYSTEM}'\n"
CONFIG="${CONFIG}window.ComposeAPI = '${API_BASEURL_COMPOSE}'\n"

if [ ! -z "${FEDERATION_ENABLED}" ]; then
  CONFIG="${CONFIG}window.FederationAPI = '${API_BASEURL_FEDERATION}'\n"
fi

echo -e "${CONFIG}" | tee \
  ${BASEDIR}/admin/config.js \
  ${BASEDIR}/compose/config.js \
> ${BASEDIR}/config.js

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

API_BASEURL=${API_BASEURL:-"${API_SCHEME}//${API_PREFIX}${VIRTUAL_HOST}"}

CONFIG="window.CortezaAPI = '${API_BASEURL}'\n"

echo -e "${CONFIG}" | tee \
  ${BASEDIR}/admin/config.js \
  ${BASEDIR}/compose/config.js \
  ${BASEDIR}/workflow/config.js \
> ${BASEDIR}/config.js

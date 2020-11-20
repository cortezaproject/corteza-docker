#!/bin/sh

set -eu

################################################################################
# (re)generate configuration files

# Where to put the configs
BASEDIR=${BASEDIR:-"/webapp"}



# See if VIRTUAL_HOST exists
# if it does, it should hold the hostname of where these webapps are served
VIRTUAL_HOST=${VIRTUAL_HOST:-"local.cortezaproject.org"}

# Assume API is using same scheme as webapps
API_SCHEME=${API_SCHEME:-""}

# Prefix to use with VIRTUAL_HOST when building API domain
API_PREFIX=${API_PREFIX:-"api."}

# Loggic differs a bit when dealing with monolith vs. microservice setup
API_BASEURL=${API_BASEURL:-"${API_PREFIX}${VIRTUAL_HOST}"}
API_BASEURL_SYSTEM=${API_BASEURL_SYSTEM:-"${API_SCHEME}//${API_BASEURL}/system"}
API_BASEURL_MESSAGING=${API_BASEURL_MESSAGING:-"${API_SCHEME}//${API_BASEURL}/messaging"}
API_BASEURL_COMPOSE=${API_BASEURL_COMPOSE:-"${API_SCHEME}//${API_BASEURL}/compose"}


tee \
  ${BASEDIR}/messaging/config.js \
  ${BASEDIR}/auth/config.js \
  ${BASEDIR}/admin/config.js \
  ${BASEDIR}/compose/config.js \
  ${BASEDIR}/config.js \
  > /dev/null \
<< EOF
window.SystemAPI = '${API_BASEURL_SYSTEM}'
window.MessagingAPI = '${API_BASEURL_MESSAGING}'
window.ComposeAPI = '${API_BASEURL_COMPOSE}'
EOF

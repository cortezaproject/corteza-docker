#!/bin/sh

set -eu

env

#curl --silent --fail-early http://127.0.0.1:${C_HTTP_PORT}/healthcheck || exit 1
curl http://127.0.0.1:${C_HTTP_PORT}/healthcheck || exit 1

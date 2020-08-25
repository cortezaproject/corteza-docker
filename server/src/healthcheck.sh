#!/bin/sh

set -eu

curl --silent --fail-early http://127.0.0.1:${C_HTTP_PORT}/healthcheck || exit 1

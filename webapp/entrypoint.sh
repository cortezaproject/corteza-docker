#!/bin/sh

set -eu

if [ ! -z "${1:-}" ]; then
	exec "$@"
else
  sh /autoconfig.sh && exec nginx -g "daemon off;"
fi

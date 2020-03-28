#!/bin/sh

set -eu

if [ ! -z "${1:-}" ]; then
	exec "$@"
else
  /usr/bin/supervisord
fi

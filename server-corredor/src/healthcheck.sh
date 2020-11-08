#!/bin/sh

set -eu



nc -z -v ${HEALTHCHECK_ADDR}

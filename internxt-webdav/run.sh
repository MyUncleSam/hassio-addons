#!/bin/sh

CONFIG_PATH=/data/options.json

export INXT_USER="$(jq -r '.user' $CONFIG_PATH)"
export INXT_PASSWORD="$(jq -r '.password' $CONFIG_PATH)"
export INXT_TWOFACTORCODE="$(jq -r '.twofactorcode // empty' $CONFIG_PATH)"
export INXT_OTPTOKEN="$(jq -r '.otptoken // empty' $CONFIG_PATH)"
export WEBDAV_PORT="$(jq -r '.webdavport' $CONFIG_PATH)"
export WEBDAV_PROTOCOL="$(jq -r '.webdavprotocol' $CONFIG_PATH)"

exec /app/docker/entrypoint.sh

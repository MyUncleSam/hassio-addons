#!/bin/sh

CONFIG_PATH=/data/options.json

echo "Checking if config exists..." >&2
ls -la /data/ >&2
echo "---" >&2

if [ -f "$CONFIG_PATH" ]; then
    echo "Config file found:" >&2
    cat $CONFIG_PATH >&2
else
    echo "ERROR: Config file not found at $CONFIG_PATH" >&2
    exit 1
fi

export INXT_USER="$(jq -r '.user' $CONFIG_PATH)"
export INXT_PASSWORD="$(jq -r '.password' $CONFIG_PATH)"
export INXT_TWOFACTORCODE="$(jq -r '.twofactorcode // empty' $CONFIG_PATH)"
export INXT_OTPTOKEN="$(jq -r '.otptoken // empty' $CONFIG_PATH)"
export WEBDAV_PORT="$(jq -r '.webdavport' $CONFIG_PATH)"
export WEBDAV_PROTOCOL="$(jq -r '.webdavprotocol' $CONFIG_PATH)"

exec /app/docker/entrypoint.sh

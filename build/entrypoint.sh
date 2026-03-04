#!/usr/bin/env sh
set -euo pipefail

: "${WEBUI_HOST:=127.0.0.1}"
: "${WEBUI_PORT:=8000}"
: "${API_HOST:=127.0.0.1}"
: "${API_PORT:=8080}"
: "${CORS_ALLOW_ORIGIN:=http://${WEBUI_HOST}:${WEBUI_PORT}}"
: "${LIGOLO_ARGS:=}"

envsubst '$WEBUI_HOST $WEBUI_PORT $API_HOST $API_PORT $CORS_ALLOW_ORIGIN' \
    < /opt/ligolo-ng/ligolo-ng.yaml.tpl \
    > /opt/ligolo-ng/ligolo-ng.yaml

nginx -g 'daemon off;' &

set -- /opt/ligolo-ng/proxy
if [ -n "${LIGOLO_ARGS:-}" ]; then
  # shellcheck disable=SC2086
  set -- "$@" ${LIGOLO_ARGS}
fi

exec "$@"

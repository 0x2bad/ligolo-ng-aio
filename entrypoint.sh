#!/usr/bin/env sh
set -euo pipefail

nginx -g 'daemon off;' &

set -- /opt/ligolo-ng/proxy
if [ -n "${LIGOLO_ARGS:-}" ]; then
  # shellcheck disable=SC2086
  set -- "$@" ${LIGOLO_ARGS}
fi

exec "$@"
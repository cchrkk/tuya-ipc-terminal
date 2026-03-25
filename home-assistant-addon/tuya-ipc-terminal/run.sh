#!/usr/bin/with-contenv bash
set -euo pipefail

RTSP_PORT="8833"
SETUP_MODE="false"
AUTH_METHOD="qr"
REGION=""
EMAIL=""
PASSWORD=""
COUNTRY_CODE=""

if [[ -f /data/options.json ]]; then
  RTSP_PORT="$(jq -r '.rtsp_port // 8833' /data/options.json)"
  SETUP_MODE="$(jq -r '.setup_mode // false' /data/options.json)"
  AUTH_METHOD="$(jq -r '.auth_method // "qr"' /data/options.json)"
  REGION="$(jq -r '.region // ""' /data/options.json)"
  EMAIL="$(jq -r '.email // ""' /data/options.json)"
  PASSWORD="$(jq -r '.password // ""' /data/options.json)"
  COUNTRY_CODE="$(jq -r '.country_code // ""' /data/options.json)"
fi

export TUYA_DATA_DIR="/data/.tuya-data"
mkdir -p "${TUYA_DATA_DIR}"

if [[ "${SETUP_MODE}" == "true" ]]; then
  if [[ -z "${REGION}" || -z "${EMAIL}" ]]; then
    echo "[setup] region and email are required when setup_mode=true"
    exit 1
  fi

  SETUP_ARGS=(auth setup "${REGION}" "${EMAIL}")

  if [[ "${AUTH_METHOD}" == "password" ]]; then
    if [[ -z "${PASSWORD}" ]]; then
      echo "[setup] password is required when auth_method=password"
      exit 1
    fi

    SETUP_ARGS+=(--password-auth --password-value "${PASSWORD}")

    if [[ -n "${COUNTRY_CODE}" ]]; then
      SETUP_ARGS+=(--country-code "${COUNTRY_CODE}")
    fi
  fi

  echo "[setup] running authentication and camera discovery"
  tuya-ipc-terminal "${SETUP_ARGS[@]}"
fi

exec tuya-ipc-terminal rtsp start --port "${RTSP_PORT}"

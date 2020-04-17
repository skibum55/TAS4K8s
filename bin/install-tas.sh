#!/usr/bin/env bash

set -euo pipefail

if [[ $# -lt 1 ]]; then
  echo "Usage $(basename "$0") <path-to-install-values-yaml>"
  exit 1
fi

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && cd .. && pwd)"
CONFIG_DIR="${BASE_DIR}/config"
CUSTOM_OVERLAYS_DIR="${BASE_DIR}/custom-overlays"

cf_install_values_path="$1"

if [[ ! -r "${cf_install_values_path}" ]]; then
  echo "Unable to read CF install values file: ${cf_install_values_path}"
  exit 1
fi

# Deploy TAS for Kubernetes
ytt \
 -f "${CONFIG_DIR}" \
 -f "${CUSTOM_OVERLAYS_DIR}" \
 -f "${cf_install_values_path}" \
 --data-values-env YTT_TAS \
 | kbld -f - -f "${BASE_DIR}/image_overrides.yml" \
 | kapp deploy -a cf -y -f -

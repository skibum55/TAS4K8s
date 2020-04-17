#!/usr/bin/env bash

# This is a hack! see https://github.com/cloudfoundry/cf-for-k8s/blob/develop/hack/README.md
set -euo pipefail

VARS_FILE="/tmp/tas-vars.yaml"

# Make sure bosh binary exists
bosh --version >/dev/null

bosh interpolate --vars-store=${VARS_FILE} <(cat <<EOF
variables:
- name: kpack_webhook_server_tls
  type: certificate
  options:
    is_ca: true
    common_name: ca
- name: kpack_webhook_server_tls_cert
  type: certificate
  options:
    ca: kpack_webhook_server_tls
    common_name: "webhook-server.build-service.svc"
    alternative_names:
    - "webhook-server.build-service.svc.cluster.local"
    - "webhook-server.build-service.svc"
    - "webhook-server"
    - "webhook-server.build-service"

EOF
) >/dev/null

cat <<EOF
#@data/values
---
kpack_webhook_server_tls:
  crt: &crt $( bosh interpolate ${VARS_FILE} --path=/kpack_webhook_server_tls_cert/certificate | base64 | tr -d '\n' )
  key: &key $( bosh interpolate ${VARS_FILE} --path=/kpack_webhook_server_tls_cert/private_key | base64 | tr -d '\n' )
  ca: $( bosh interpolate ${VARS_FILE} --path=/kpack_webhook_server_tls_cert/ca | base64 | tr -d '\n' )
EOF

#!/usr/bin/env bash

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" > /dev/null 2>&1 && cd .. && pwd)"

"$REPO_DIR/config/cf-for-k8s/hack/generate-values.sh" "$@"
"$REPO_DIR/hack/generate-values.sh"

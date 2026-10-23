#!/usr/bin/env bash
set -euo pipefail

# Keep one reviewed kops setup path. This wrapper delegates to the safer
# parameterized flow, which verifies AWS identity and bucket versioning and
# does not apply cloud infrastructure without a separate reviewed command.
script_dir="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"
exec "${script_dir}/ubuntu-kops.sh" "$@"

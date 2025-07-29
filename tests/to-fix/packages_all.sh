#!/bin/bash
## This script outputs all of the packages that has explicitly supports.
set -euo pipefail

pushd "$(dirname "${BASH_SOURCE[0]}")" >/dev/null

grep -o "^ \\+[a-zA-Z0-9_|-]\\+)" ../../has | grep -o "[a-zA-Z0-9_|-]\\+" | tr "|" "\\n" | sort -f | sed '1,3d'

popd >/dev/null

#!/usr/bin/env bash

set -euo pipefail

# Output lidarr version from github:lidarr releases
echo "$(curl -fsSL --retry 5 --retry-delay 2 https://services.lidarr.audio/v1/update/master/changes?os=linux | jq -r '.[0].version')"

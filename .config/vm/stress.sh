#!/usr/bin/env bash
set -Eeuo pipefail

_echo() {
  echo "\033[36m$*\033[0m"
}

# install stress test toolkit
sudo apt install stress-ng

# basic CPU test
_echo "Basic CPU test"
stress-ng --cpu 0 --timeout 1m --metrics

# heavy CPU test
_echo "Heavy CPU test"
stress-ng --cpu 0 --cpu-method matrixprod --metrics --verify --timeout 1m

# basic RAM test
_echo "Basic RAM test"
stress-ng --vm 2 --vm-bytes 80% --timeout 1m --metrics

# heavy RAM test
_echo "Heavy RAM test"
stress-ng --vm 4 --vm-bytes 90% --vm-method all --verify --timeout 1m

# CPU + RAM test
_echo "CPU + RAM test"
stress-ng --cpu 0 --vm 4 --vm-bytes 75% --timeout 1m --metrics

#!/usr/bin/env bash
set -euo pipefail

n="${1:-5}"

while [ "$n" -gt 0 ]; do
	echo "n=$n"
	n=$((n - 1))
	sleep 1
done

echo "done"

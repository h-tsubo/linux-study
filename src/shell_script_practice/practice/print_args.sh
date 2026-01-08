#!/usr/bin/env bash
set -euo pipefail

i=1
for arg in "$@"; do
	echo "arg[$i]=$arg"
	i=$((i + 1))
done

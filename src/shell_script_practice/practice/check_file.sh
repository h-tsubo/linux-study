#!/usr/bin/env bash
set -euo pipefail

if [ $# -ne 1 ]; then
	echo "Usage: $0 <file>"
	exit 2
fi

file="$1"

if [ -f "$file" ]; then
	echo "OK: file exists: $file"
else
	echo "NG: file not found: $file"
	exit 1
fi

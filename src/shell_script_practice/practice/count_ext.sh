#!/usr/bin/env bash
set -euo pipefail

txt=0
log=0
other=0

for f in "$@"; do
	if [[ "$f" == *.txt ]]; then
		txt=$((txt + 1))
	elif [[ "$f" == *.log ]]; then
		log=$((log + 1))
	else
		other=$((other + 1))
	fi
done

echo "txt=$txt"
echo "log=$log"
echo "other=$other"

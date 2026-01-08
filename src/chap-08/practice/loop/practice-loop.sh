#!/usr/bin/env bash
set -euo pipefail

i=1

while true; do
	echo "$(date '+%F %T') loop count=$i"
	((i++))
	sleep 3
	if ((i > 5)); then
		exit 1;
	fi
done

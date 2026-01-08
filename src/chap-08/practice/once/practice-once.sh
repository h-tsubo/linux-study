#!/usr/bin/env bash
set -euo pipefail

if [ ! -d ./tmp ]; then
	mkdir ./tmp
fi

echo "start: $(date)" >> /tmp/practice-once.log
sleep 2
echo "end: $(date)" >> /tmp/practice-once.log

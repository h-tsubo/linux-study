#!/usr/bin/env bash
set -euo pipefail

x=$1

y=$((x + 1))

if ((x > 3)); then
	echo "x = $x > 3"
else
	echo "x = $x <= 3"
fi

if ((y > 3)); then
	echo "y= $y > 3"
else
	echo "y= $y <= 3"
fi
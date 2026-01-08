#!/usr/bin/env bash
set -euo pipefail

case "${1:-}" in
	start)
		echo "starting..."
		;;
	stop)
		echo "stopping..."
		;;
	status)
		echo "status: OK"
		;;
	*)
		echo "Usage: $0 {start|stop|status}"
		exit 2
		;;
esac
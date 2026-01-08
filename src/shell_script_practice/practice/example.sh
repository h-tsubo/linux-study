#!/usr/bin/env bash
if ls /etc > /dev/null; then
	echo "成功"
else 
	echo "失敗"
fi
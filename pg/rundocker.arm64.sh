#!/bin/bash

found=$(docker images |grep "pandagroove/tgsearch" |grep arm64 |wc -l)

if [ $found -eq 0 ]; then
	gzip -dc tgsearch.docker.arm64.tar.gz | docker load
fi

found=$(cat docker-compose.arm64.yml |grep "STRINGSESSION: \"\"" |wc -l)
if [ $found -eq 0 ]; then
	echo "session string is set, run in background"
	docker-compose -f docker-compose.arm64.yml up -d
else
	echo "session string is NOT set, run in foreground for see errors."
	docker-compose -f docker-compose.arm64.yml up
fi


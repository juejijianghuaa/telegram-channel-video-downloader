#!/bin/bash

prog="$0"
while [ -h "${prog}" ]; do
	newProg=`/bin/ls -ld "${prog}"`

	newProg=`expr "${newProg}" : ".* -> \(.*\)$"`
	if expr "x${newProg}" : 'x/' >/dev/null; then
		prog="${newProg}"
	else
		progdir=`dirname "${prog}"`
		prog="${progdir}/${newProg}"
	fi
done
progdir=`dirname "${prog}"`
cd "${progdir}"

version=1.3.6-alpine

found=$(docker images |grep "pandagroove/tgsearch:${version}" |wc -l)

if [ $found -eq 0 ]; then
	gzip -dc tgsearch.docker.${version}.tar.gz | docker load
fi

compose=""
have=$(docker compose -h |grep compose|wc -l)
if [ $have -gt 0 ]; then
	compose="docker compose"
else
	docker-compose -h 2>&1 >/dev/null
	if [ $? -eq 0 ]; then
		compose="docker-compose"
	else
		echo "no docker compose, exit"
		exit 1
	fi
fi

echo "compose:$compose"

mkdir tmp
chmod 777 tmp

$compose -f docker-compose.yml down >/dev/null 2>&1
found=$(cat docker-compose.yml |grep "STRINGSESSION"|sed -e "s/.*STRINGSESSION//"|wc -c)
if [ $found -gt 10 ]; then
	echo "session string is set, run in background"
	$compose -f docker-compose.yml up -d
else
	echo "session string is NOT set, run in foreground for see errors."
	$compose -f docker-compose.yml up
fi


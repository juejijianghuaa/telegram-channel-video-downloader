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

version=1.2.4-alpine

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

$compose -f docker-compose.yml down

#!/bin/bash

#define below env by yourself.
export API_ID=""
export API_HASH=""
export SESSIONSTRING=""
export API_PROXY=""
#define end

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

if [ "$API_ID" = "" ] && [ -e env.sh ]; then
	echo "not set API_ID and found env.sh, source it."
	source ./env.sh
fi

OS=$(uname)
ARCH=$(uname -m)

PROG="tgsearch.x86_64"
if [ "$OS" = "Linux" ]; then
       	if [ "$ARCH" = "x86_64" ]; then
		echo "X86 64bit Linux system."
       	elif [[ "$ARCH" == *"arm64"* ]] || [[ "$ARCH" == *"aarch64"* ]]; then
		echo "ARM-based 64bit Linux system."
		PROG="tgsearch.arm64v8"
	elif [[ "$ARCH" == *"arm"* ]]; then
		echo "ARM-based 32bit Linux system."
		PROG="tgsearch.arm32v7"
	else
		echo "NOT support Linux system. exit"
		exit
	fi
else
	echo "NOT support platform: $OS on $ARCH"
	exit
fi

chmod u+x $PROG

if [[ "$@" == *"nohup"* ]]; then
	echo "run with nohup..."
	nohup ./${PROG} $1 $2 $3 $4 $5 $6 $7 $8 $9 &
else
	echo "direct run ..."
	./${PROG} $1 $2 $3 $4 $5 $6 $7 $8 $9
fi

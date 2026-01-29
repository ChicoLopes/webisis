#!/bin/bash

if [ $# = 0 ]; then
	echo "Sintaxe: $(basename $0) <MF_name> [<CISIS flavour>]"
else
	if [ $2 ]; then
		$2/mx $1 +control count=0 | tail -1 | awk '{ print $1-1 }'
	else
		mx $1 +control count=0 | tail -1 | awk '{ print $1-1 }'
	fi
fi

#!/bin/bash

set -e

PIP=$1
FILENAME=$2
LOGFILE=$3
while read line
do
    "$PIP" install --log "$LOGFILE" "$line"
done < "$FILENAME"


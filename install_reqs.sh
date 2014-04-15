#!/bin/bash

set -e

PIP=$1
FILENAME=$2
LOGFILE=$3
while read line
do
    echo "$PIP" install --log "$LOGFILE" "$line"
    "$PIP" install --log "$LOGFILE" "$line"
done < "$FILENAME"


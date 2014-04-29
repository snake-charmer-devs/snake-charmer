#!/bin/bash

set -e

PIP=$1
FILENAME=$2
LOGFILE=$3
DL_CACHE=$4

while read line
do
  if [[ "$line" = git+http* ]]
  then
    "$PIP" install --no-clean --log "$LOGFILE" --download-cache "$DL_CACHE" -e "$LINE" 
  else
    "$PIP" install --no-clean --log "$LOGFILE" --download-cache "$DL_CACHE" "$line"
  fi
done < "$FILENAME"


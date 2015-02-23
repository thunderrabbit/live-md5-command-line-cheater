#!/bin/bash

target="$1"

echo searching for $target

# read each line of a file or output stream
while read line
do
    hash="$(echo -n "$line" | md5)"
    if echo $hash | grep $target$;
    then
       echo $line
    fi
done

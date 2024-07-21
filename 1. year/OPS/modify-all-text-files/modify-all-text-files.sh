#!/usr/bin/env bash

files=$(ls *.txt)

for file in $files; do
 echo $file
 echo "I was here, Hacker." >> $file
done

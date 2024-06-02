#!/usr/bin/env bash

text1=$(cat "$1")
text2=$(cat "$2")
text="${text1}\n${text2}"
echo -e "$text" > concat.txt

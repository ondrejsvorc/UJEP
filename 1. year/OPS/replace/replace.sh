#!/usr/bin/env bash

text_path=$1
text=$(cat $text_path)
text_new=$(echo $text | tr "iy" "_")
echo $text_new

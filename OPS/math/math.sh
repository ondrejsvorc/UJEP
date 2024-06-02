#!/usr/bin/env bash

exercises_count=$1
output_file_path=$2

touch $output_file_path

signs=("+" "-")
sign_equal="="

for _ in $(seq 1 $exercises_count); do
 first_number=$((RANDOM % 101))
 second_number=$((RANDOM % 101))

 random_sign_index=$((RANDOM % ${#signs[@]}))
 sign=${signs[$random_sign_index]}

 exercise="${first_number} ${sign} ${second_number} ${sign_equal}"
 echo $exercise >> $output_file_path
done

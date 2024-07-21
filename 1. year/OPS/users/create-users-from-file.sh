#!/usr/bin/env bash

users_file_path=$1

cat $users_file_path | while read user; do
 echo "Adding user: $user"
 useradd "$user"
done

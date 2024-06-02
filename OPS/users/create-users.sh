#!/usr/bin/env bash

users="$@"

for user in $users; do
 echo "Adding user: $user" 
 useradd "$user"
done

#!/usr/bin/env bash

users="/etc/passwd"

min_uid=1000
max_uid=60000

tac $users | while IFS=: read -r username password uid gid fullname home shell; do
 if (( uid < min_uid || uid > max_uid )); then
  continue
 fi 

 echo "User: $username, UID: $uid"
done

#!/bin/bash

users_path=$1
while read -r username
do
  useradd "$username"
done < $users_path

# Skript, kterému předáme seznam uživatelů, a ten je vytvoří.
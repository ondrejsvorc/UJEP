#!/usr/bin/env bash

backup() {
 local source=$1
 local destination=$2
 cp "$source" "$destination"
}

backup $1 $2

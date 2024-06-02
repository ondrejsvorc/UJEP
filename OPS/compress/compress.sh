#!/usr/bin/env bash

compressed_folder_name="images"
mkdir -p $compressed_folder_name

images=$(ls *.{jpg,png})

for image in $images; do
 mv "$image" "$compressed_folder_name/$image"
done

tar -cf "$compressed_folder_name.tar.gz" "$compressed_folder_name"

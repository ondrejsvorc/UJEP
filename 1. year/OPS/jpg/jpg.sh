find / -type f -iname "*jpg" 2>/dev/null | while read -r image;                 
do                                                                              
  echo "$image"                                                                 
done
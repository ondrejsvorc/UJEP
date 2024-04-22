#!/bin/bash                                                                     
                                                                                
touch output.txt                                                                
for file in $@                                                                
do                                                                              
 cat $file >> output.txt                                                      
done 
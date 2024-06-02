#!/bin/bash                                                                     
                                                                                
sum=0                                                                        
for number in $@                                                                 
do                                                                              
 sum=$((sum + number))                                                     
done                                                                            
                                                                                
average=$((sum / $#))                                                         
                                                                                
echo "Sum: $sum"                                                        
echo "Average: $average"
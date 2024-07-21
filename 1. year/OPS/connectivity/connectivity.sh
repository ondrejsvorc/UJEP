#!/bin/bash                                                                                                                                           
                                                                                
success_count=0                                                                 
fail_count=0

file_path=$1

while read -r row
do
 echo "Testuji... $row"
 if ping -c 5 "$row" &> /dev/null
 then                                                                           
   echo "$row odpovida"
   ((success_count++))
 else                                                                           
   echo "$row neodpovida"
   ((fail_count++))
 fi
done < $file_path

echo "Uspesne: $success_count"
echo "Neuspesne: $fail_count"

# Skript, který přečte seznam serverů ze souboru a pingne je. Vypište, kolik testů prošlo a kolik neprošlo.
# Prerekvizity: textový soubor s názvy domén na jednotlivých řádcích
# Spuštění: ./connectivity.sh "servers.txt"
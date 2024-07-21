while IFS=":" read -r f1 f2 f3
do
  echo $f1
  echo $f2
  echo $f3
done < "data.txt"

# data.txt
# jmeno:prijmeni:plat
# jan:novak:21500
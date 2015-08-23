#!/bin/bash

# Version 1.0, 20150821, Harry van der Wolf

# All windows files with .exe as I almost completely copy&paste the scripts

mkdir workfiles

# Get the postcode zips
# Below the UK postcodes database. It only contains the prefix
wget http://www.ukpostcodes.org/downloads/uk-postcode-database-csv.zip -O workfiles/uk-postcode-database-csv.zip
unzip -o workfiles/uk-postcode-database-csv.zip -d workfiles

# Below the "Doogal" \(Cris Bell\) UK postcodes download
wget http://www.doogal.co.uk/files/postcodes.zip -O workfiles/postcodes.zip
unzip -o workfiles/postcodes.zip -d workfiles
echo =====
echo Remove the header from the the postcodes.csv file
echo =====
grep -v "Introduced,Terminated" workfiles/postcodes.csv > workfiles/postcodes2.csv
mv -f workfiles/postcodes2.csv workfiles/postcodes.csv

echo ===== 
echo Your postcode files are now ready for further processing in sqlite.

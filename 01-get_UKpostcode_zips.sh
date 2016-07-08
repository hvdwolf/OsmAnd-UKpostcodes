#!/bin/bash

# Version 1.0, 20150821, Harry van der Wolf

# All windows files with .exe as I almost completely copy&paste the scripts

mkdir workfiles

# Get the postcode zips
# All from the  "Doogal" \(Cris Bell\) UK postcodes website
wget http://www.doogal.co.uk/files/postcodes.zip -O workfiles/postcodes.zip
unzip -o workfiles/postcodes.zip -d workfiles

wget http://www.doogal.co.uk/files/PostcodeDistrictsSplit.csv -O workfiles/PostcodeDistrictsSplit.csv
echo =====
echo Remove the header from the the postcodes.csv file
echo =====
grep -v "Introduced,Terminated" workfiles/postcodes.csv > workfiles/postcodes2.csv
mv -f workfiles/postcodes2.csv workfiles/postcodes.csv

grep -v Postcode workfiles/PostcodeDistrictsSplit.csv > workfiles/PostcodeDistrictsSplit2.csv
mv -f  workfiles/PostcodeDistrictsSplit2.csv  workfiles/PostcodeDistrictsSplit.csv

echo ===== 
echo Your postcode files are now ready for further processing in sqlite.

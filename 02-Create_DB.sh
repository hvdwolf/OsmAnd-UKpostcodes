#!/bin/bash

# Version 2.0. 201607, Harry van der Wolf
# Version 1.0, 20150821, Harry van der Wolf

# Requirements sqlite3


# Do some preprocessing on the files
grep -v "Introduced,Terminated" workfiles/postcodes.csv > workfiles/postcodes2.csv
mv -f workfiles/postcodes2.csv workfiles/postcodes.csv

grep -v Population workfiles/Postcodedistricts.csv > workfiles/Postcodedistricts2.csv
mv workfiles/Postcodedistricts2.csv workfiles/Postcodedistricts.csv


# First remove any existing Database
echo Remove existing database as I want to start clean
echo ===

rm workfiles/UK_postcodes.db
# Create DB, import csv files, do the rest of the stuff
cat import.sql | sqlite3 workfiles/UK_postcodes.db

echo Now we can get rid of our csv files as especially the postcodes\.csv is 600MB\+ in size
rm workfiles/*.csv

echo ===
echo Done importing! Now you can continue with the 03 script

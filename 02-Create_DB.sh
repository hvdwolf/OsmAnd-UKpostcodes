#!/bin/bash

# Version 1.0, 20150821, Harry van der Wolf

# All windows files with .exe as I almost completely copy&paste the scripts

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
